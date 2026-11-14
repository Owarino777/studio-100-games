#!/usr/bin/env python3
"""Serve only a frozen Godot Web export; loopback by default, no publication."""
from __future__ import annotations

import argparse
import base64
import gzip
import hashlib
import hmac
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
import os
from pathlib import Path
import socket
import ssl
from urllib.parse import unquote, urlsplit

GAME = Path(__file__).resolve().parents[1]
ALLOWED = {
    "index.html": "text/html; charset=utf-8", "index.js": "application/javascript",
    "index.wasm": "application/wasm", "index.pck": "application/octet-stream",
    "index.png": "image/png", "index.icon.png": "image/png",
    "index.apple-touch-icon.png": "image/png",
    "index.audio.worklet.js": "application/javascript",
    "index.audio.position.worklet.js": "application/javascript",
}


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--root", type=Path, default=GAME / "build/web-safari")
    parser.add_argument("--host", choices=["127.0.0.1", "0.0.0.0"], default="127.0.0.1")
    parser.add_argument("--port", type=int, default=8765)
    parser.add_argument("--cert", type=Path)
    parser.add_argument("--key", type=Path)
    parser.add_argument("--password-file", type=Path, help="Optional local Basic auth secret, user studio")
    args = parser.parse_args()
    if not 1024 <= args.port <= 65535:
        parser.error("choose an unprivileged local port")
    if bool(args.cert) != bool(args.key):
        parser.error("provide both TLS certificate and key")
    if args.host != "127.0.0.1" and not (args.cert and args.password_file):
        parser.error("LAN exposure requires TLS and authentication, after owner approval")
    directory = args.root.resolve(strict=True)
    expected_root = (GAME / "build").resolve()
    if not directory.is_relative_to(expected_root):
        parser.error("serve only an export inside this game's build directory")
    password = args.password_file.read_text(encoding="utf-8").strip() if args.password_file else None
    if password is not None and len(password) < 24:
        parser.error("authentication secret must contain at least 24 characters")
    content: dict[str, tuple[bytes, str, str]] = {}
    for name, mime in ALLOWED.items():
        path = directory / name
        if path.is_file():
            if path.is_symlink() or path.resolve().parent != directory:
                parser.error("export links are not served")
            data = path.read_bytes()
            content[name] = (data, mime, hashlib.sha256(data).hexdigest())
    if not {"index.html", "index.js", "index.wasm", "index.pck"} <= content.keys():
        parser.error("complete Godot export required")
    compressed: dict[str, bytes] = {}

    class Handler(BaseHTTPRequestHandler):
        def log_message(self, format, *values):
            # Do not log credentials, URLs, query strings, or tester IP addresses.
            return

        def do_HEAD(self):
            self.respond(False)

        def do_GET(self):
            self.respond(True)

        def respond(self, body: bool):
            if password is not None:
                supplied = self.headers.get("Authorization", "")
                authorized = False
                try:
                    scheme, token = supplied.split(" ", 1)
                    if scheme.lower() == "basic":
                        credentials = base64.b64decode(token, validate=True).decode("utf-8")
                        user, separator, candidate = credentials.partition(":")
                        # One temporary test account; tolerate mobile keyboard casing
                        # and accidental outer clipboard whitespace, not wrong secrets.
                        authorized = bool(separator) and user.strip().lower() == "studio" and hmac.compare_digest(candidate.strip().encode("utf-8"), password.encode("utf-8"))
                except (ValueError, UnicodeError):
                    pass
                if not authorized:
                    self.send_response(401)
                    self.send_header("WWW-Authenticate", 'Basic realm="SWITCHWORKS private test"')
                    self.send_header("Cache-Control", "no-store")
                    self.send_header("Content-Length", "0")
                    self.end_headers()
                    return
            requested = unquote(urlsplit(self.path).path)
            name = "index.html" if requested in ["/", "/index.html"] else requested.removeprefix("/")
            if name not in content:
                self.send_error(404)
                return
            data, mime, digest = content[name]
            zipped = "gzip" in self.headers.get("Accept-Encoding", "") and mime != "image/png"
            if zipped:
                if name not in compressed:
                    compressed[name] = gzip.compress(data, compresslevel=6, mtime=0)
                data = compressed[name]
            self.send_response(200)
            self.send_header("Content-Type", mime)
            self.send_header("Content-Length", str(len(data)))
            self.send_header("Cache-Control", "no-store" if name == "index.html" or password else "private, max-age=3600")
            self.send_header("ETag", '"' + digest + '"')
            self.send_header("Vary", "Accept-Encoding, Authorization")
            self.send_header("X-Content-Type-Options", "nosniff")
            self.send_header("Referrer-Policy", "no-referrer")
            self.send_header("Permissions-Policy", "camera=(), microphone=(), geolocation=()")
            self.send_header("Content-Security-Policy", "default-src 'self' blob: data:; script-src 'self' 'unsafe-inline' 'unsafe-eval' 'wasm-unsafe-eval' blob:; worker-src 'self' blob:; style-src 'self' 'unsafe-inline'; frame-ancestors 'none'")
            if zipped:
                self.send_header("Content-Encoding", "gzip")
            self.end_headers()
            if body:
                try:
                    self.wfile.write(data)
                except (BrokenPipeError, ConnectionResetError):
                    pass

    class ExclusiveServer(ThreadingHTTPServer):
        allow_reuse_address = False

        def server_bind(self):
            if os.name == "nt":
                self.socket.setsockopt(socket.SOL_SOCKET, socket.SO_EXCLUSIVEADDRUSE, 1)
            super().server_bind()

    server = ExclusiveServer((args.host, args.port), Handler)
    if args.cert:
        context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
        context.minimum_version = ssl.TLSVersion.TLSv1_2
        context.load_cert_chain(args.cert, args.key)
        server.socket = context.wrap_socket(server.socket, server_side=True)
    print(json.dumps({"scope": "local frozen Godot export only", "bind": args.host, "port": args.port,
                      "tls": bool(args.cert), "authentication": password is not None,
                      "served_files": len(content), "pck_sha256": content["index.pck"][2]}), flush=True)
    try:
        server.serve_forever()
    finally:
        server.server_close()


if __name__ == "__main__":
    main()
