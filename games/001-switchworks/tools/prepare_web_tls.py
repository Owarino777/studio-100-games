#!/usr/bin/env python3
"""Prepare local-only TLS files. Does not trust/install certificates or open ports."""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import hashlib
import ipaddress
import json
from pathlib import Path
import plistlib
import secrets
import shutil
import subprocess
import uuid

ROOT = Path(__file__).resolve().parents[3]


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--lan-ip", required=True)
    args = parser.parse_args()
    address = ipaddress.ip_address(args.lan_ip)
    if address.version != 4 or not address.is_private or address.is_loopback:
        parser.error("use the PC's private Wi-Fi IPv4 address")
    openssl = shutil.which("openssl") or r"C:\Program Files\Git\usr\bin\openssl.exe"
    if not Path(openssl).is_file():
        parser.error("reuse an installed OpenSSL; no automatic installation")
    folder = ROOT / "tools/.local/web-https" / datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")
    folder.mkdir(parents=True, exist_ok=False)
    def command(*arguments: str) -> None:
        result = subprocess.run([openssl, *arguments], cwd=folder, capture_output=True, timeout=30)
        if result.returncode:
            raise RuntimeError("TLS preparation failed: " + result.stderr.decode(errors="replace")[-500:])
    command("req", "-x509", "-newkey", "rsa:2048", "-nodes", "-sha256", "-days", "3",
            "-subj", "/CN=SWITCHWORKS local test CA", "-keyout", "ca.key", "-out", "ca.pem",
            "-addext", "basicConstraints=critical,CA:TRUE,pathlen:0",
            "-addext", "keyUsage=critical,keyCertSign,cRLSign")
    command("req", "-new", "-newkey", "rsa:2048", "-nodes", "-subj", "/CN=SWITCHWORKS local Web test",
            "-keyout", "server.key", "-out", "server.csr")
    extensions = ("basicConstraints=critical,CA:FALSE\nkeyUsage=critical,digitalSignature,keyEncipherment\n"
                  "extendedKeyUsage=serverAuth\nsubjectAltName=IP:" + str(address) + ",IP:127.0.0.1,DNS:localhost\n")
    (folder / "server.ext").write_text(extensions, encoding="ascii")
    command("x509", "-req", "-in", "server.csr", "-CA", "ca.pem", "-CAkey", "ca.key",
            "-CAcreateserial", "-days", "3", "-sha256", "-extfile", "server.ext", "-out", "server.pem")
    command("x509", "-in", "ca.pem", "-outform", "der", "-out", "studio-test-ca.cer")
    certificate = (folder / "studio-test-ca.cer").read_bytes()
    identifier = str(uuid.uuid4())
    profile = {"PayloadType": "Configuration", "PayloadVersion": 1,
               "PayloadIdentifier": "com.studio100games.webtest." + identifier,
               "PayloadUUID": identifier, "PayloadDisplayName": "SWITCHWORKS HTTPS local temporaire",
               "PayloadDescription": "Certificat de test local uniquement. Supprimer ce profil apres les essais. Aucun MDM, VPN ou proxy.",
               "PayloadRemovalDisallowed": False,
               "PayloadContent": [{"PayloadType": "com.apple.security.root", "PayloadVersion": 1,
                                   "PayloadIdentifier": "com.studio100games.webtest.ca." + identifier,
                                   "PayloadUUID": str(uuid.uuid4()), "PayloadDisplayName": "SWITCHWORKS local test CA",
                                   "PayloadContent": certificate}]}
    (folder / "studio-test.mobileconfig").write_bytes(plistlib.dumps(profile))
    (folder / "access-secret.txt").write_text(secrets.token_urlsafe(32), encoding="ascii")
    metadata = {"scope": "prepared files only; nothing installed/trusted/published",
                "lan_ip": str(address), "proposed_url": f"https://{address}:8766/",
                "certificate_duration_days": 3,
                "ca_der_sha256": hashlib.sha256(certificate).hexdigest(),
                "profile_sha256": hashlib.sha256((folder / "studio-test.mobileconfig").read_bytes()).hexdigest(),
                "approval_required": "iPhone certificate profile and SSL trust; local firewall if needed; no external publication",
                "private_keys": "local ignored folder only, never part of served Godot allowlist"}
    (folder / "prepared.json").write_text(json.dumps(metadata, indent=2) + "\n", encoding="utf-8")
    print(folder)
    print(json.dumps(metadata, indent=2))


if __name__ == "__main__":
    main()
