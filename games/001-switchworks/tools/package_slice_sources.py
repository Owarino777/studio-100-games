#!/usr/bin/env python3
"""Package the studio working-tree sources, without Git metadata or local tooling.

Python 3.10+; standard library only. No build, commit, network or publication action.
"""

from __future__ import annotations

import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import stat
import subprocess
import sys
import zipfile


MANIFEST_NAME = "SOURCE_ARCHIVE_MANIFEST.json"
MAX_FILE_BYTES = 64 * 1024 * 1024
WINDOWS_DEVICE_NAMES = frozenset({"CON", "PRN", "AUX", "NUL"} | {
    prefix + str(number) for prefix in ("COM", "LPT") for number in range(1, 10)
})
BLOCKED_PARTS = frozenset({
    ".git", ".local", ".godot", ".aws", ".ssh", ".codex", ".vs",
    "build", "dist", "artifacts", "node_modules", "__pycache__", "imports",
})
BLOCKED_SUFFIXES = frozenset({
    ".key", ".pem", ".p8", ".p12", ".pfx", ".jks", ".keystore",
    ".mobileprovision", ".provisionprofile", ".apk", ".aab", ".apks",
    ".idsig", ".zip", ".tpz", ".pck", ".exe", ".dll", ".pyc", ".pyo",
})
BLOCKED_NAMES = frozenset({
    "export_credentials.cfg", "local.properties", "credentials", "credentials.json",
    "credentials.ini", "credentials.yaml", "credentials.yml", "secrets.json",
    "secrets.yaml", "secrets.yml", ".netrc", "_netrc", ".npmrc", ".pypirc",
    ".gitconfig", "id_rsa", "id_ed25519", "adbkey", "adbkey.pub", "thumbs.db",
    ".ds_store",
})
SECRET_PATTERNS = {
    "private key": rb"-----BEGIN (?:RSA |EC |OPENSSH |DSA |ENCRYPTED )?PRIVATE KEY-----",
    "GitHub token": rb"\b(?:gh[pousr]_[A-Za-z0-9]{30,}|github_pat_[A-Za-z0-9_]{50,})\b",
    "AWS access key": rb"\b(?:AKIA|ASIA)[A-Z0-9]{16}\b",
    "Google API key": rb"\bAIza[0-9A-Za-z_-]{30,}\b",
    "OpenAI API key": rb"\bsk-(?:proj-|svcacct-)?[A-Za-z0-9_-]{30,}\b",
    "Slack token": rb"\bxox[baprs]-[A-Za-z0-9-]{20,}\b",
    "JWT": rb"\beyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\b",
    "credential URL": rb"https?://[^\s/:@]+:[^\s/@]+@",
    "secret assignment": rb'''(?i)\b(?:api[_-]?key|access[_-]?token|client[_-]?secret|password|private[_-]?key)\b\s*[:=]\s*["'](?!\$|<|your|example|test|placeholder|res://|user://)[A-Za-z0-9_+/=-]{16,}["']''',
}


class PackagingError(RuntimeError):
    """An actionable packaging failure, without exposing a detected secret value."""


def safe_relative(name: str) -> PurePosixPath:
    parts = name.split("/")
    if (not name or "\\" in name or name.startswith("/")
            or any(part in {"", ".", ".."} for part in parts)
            or any(part.endswith((".", " ")) or part.split(".")[0].upper() in WINDOWS_DEVICE_NAMES for part in parts)
            or any(ord(character) < 32 for character in name)
            or any(character in '<>:"|?*' for character in name)):
        raise PackagingError(f"Unsafe source/archive path: {name!r}")
    path = PurePosixPath(name)
    if path.is_absolute():
        raise PackagingError(f"Absolute path is not allowed: {name!r}")
    return path


def blocked_reason(name: str) -> str | None:
    path = safe_relative(name)
    if any(part.casefold() in BLOCKED_PARTS for part in path.parts):
        return "local metadata, cache or build directory"
    basename = path.name.casefold()
    if basename in BLOCKED_NAMES or (basename.startswith(".env") and basename != ".env.example"):
        return "sensitive or machine-local filename"
    if path.suffix.casefold() in BLOCKED_SUFFIXES:
        return "private key, local executable or generated package extension"
    return None


def git_query(root: Path, *arguments: str, allow_failure: bool = False) -> bytes:
    environment = os.environ.copy()
    for key in ("GIT_DIR", "GIT_WORK_TREE", "GIT_INDEX_FILE", "GIT_COMMON_DIR",
                "GIT_OBJECT_DIRECTORY", "GIT_ALTERNATE_OBJECT_DIRECTORIES"):
        environment.pop(key, None)
    command = ["git", "-c", f"safe.directory={root.as_posix()}", "-C", str(root), *arguments]
    try:
        result = subprocess.run(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                                env=environment, timeout=60, check=False)
    except (OSError, subprocess.TimeoutExpired) as error:
        raise PackagingError("Git is unavailable or its local query timed out.") from error
    if result.returncode and not allow_failure:
        raise PackagingError("Git query failed; run this tool from its studio Git checkout.")
    return result.stdout if result.returncode == 0 else b""


def inventory(root: Path) -> tuple[list[str], list[dict[str, str]]]:
    top = git_query(root, "rev-parse", "--show-toplevel").decode("utf-8").strip()
    if Path(top).resolve() != root.resolve():
        raise PackagingError("The Git root differs from the studio source root.")
    raw = git_query(root, "ls-files", "--cached", "--others", "--exclude-standard", "-z")
    try:
        candidates = sorted(set(value.decode("utf-8") for value in raw.split(b"\0") if value))
    except UnicodeDecodeError as error:
        raise PackagingError("Git returned a filename that is not UTF-8.") from error
    accepted: list[str] = []
    excluded: list[dict[str, str]] = []
    case_names: set[str] = set()
    for name in candidates:
        reason = blocked_reason(name)
        if reason:
            excluded.append({"path": name, "reason": reason})
            continue
        if name.casefold() == MANIFEST_NAME.casefold():
            raise PackagingError(f"Reserved generated manifest name already exists: {name}")
        if name.casefold() in case_names:
            raise PackagingError(f"Case-insensitive filename collision: {name}")
        case_names.add(name.casefold())
        accepted.append(name)
    if not accepted:
        raise PackagingError("No source files were selected by Git.")
    return accepted, excluded


def source_path(root: Path, name: str) -> Path:
    relative = safe_relative(name)
    path = root.joinpath(*relative.parts)
    current = root
    for part in relative.parts:
        current = current / part
        if current.is_symlink() or (hasattr(current, "is_junction") and current.is_junction()):
            raise PackagingError(f"Source links/junctions are not packaged: {name}")
    if not path.resolve(strict=True).is_relative_to(root.resolve()):
        raise PackagingError(f"Source resolved outside the studio: {name}")
    if not stat.S_ISREG(path.stat().st_mode):
        raise PackagingError(f"Source is not a regular file: {name}")
    return path


def check_secrets(name: str, data: bytes) -> None:
    for kind, pattern in SECRET_PATTERNS.items():
        match = re.search(pattern, data)
        if match:
            line = data.count(b"\n", 0, match.start()) + 1
            raise PackagingError(f"Secret-like content ({kind}) in {name}, line {line}; value hidden.")


def read_source(root: Path, name: str) -> tuple[bytes, os.stat_result]:
    path = source_path(root, name)
    before = path.stat()
    if before.st_size > MAX_FILE_BYTES:
        raise PackagingError(f"Source exceeds the 64 MiB review limit: {name}")
    data = path.read_bytes()
    after = path.stat()
    if (before.st_size, before.st_mtime_ns) != (after.st_size, after.st_mtime_ns):
        raise PackagingError(f"Source changed while being read: {name}")
    check_secrets(name, data)
    return data, after


def verify_archive(path: Path) -> dict[str, int]:
    with zipfile.ZipFile(path, "r") as archive:
        infos = archive.infolist()
        names = [item.filename for item in infos]
        if len(names) != len(set(name.casefold() for name in names)):
            raise PackagingError("Archive contains duplicate or case-colliding entries.")
        for item in infos:
            safe_relative(item.filename)
            if item.flag_bits & 1:
                raise PackagingError("Encrypted archive entries are not supported.")
            if item.is_dir() or stat.S_ISLNK(item.external_attr >> 16):
                raise PackagingError("Archive must contain regular files only.")
            if item.file_size > MAX_FILE_BYTES:
                raise PackagingError("Archive entry exceeds the 64 MiB review limit.")
            if item.filename != MANIFEST_NAME and blocked_reason(item.filename):
                raise PackagingError(f"Archive contains an excluded path: {item.filename}")
        if MANIFEST_NAME not in names:
            raise PackagingError("Archive has no integrated source manifest.")
        manifest = json.loads(archive.read(MANIFEST_NAME).decode("utf-8"))
        if not isinstance(manifest, dict) or manifest.get("schema_version") != 1 or not isinstance(manifest.get("files"), list):
            raise PackagingError("Archive manifest schema is invalid.")
        records = manifest["files"]
        if len(records) != len({record["path"] for record in records}):
            raise PackagingError("Manifest repeats a source path.")
        if set(names) != {record["path"] for record in records} | {MANIFEST_NAME}:
            raise PackagingError("Archive contents differ from the integrated manifest.")
        for record in records:
            data = archive.read(record["path"])
            check_secrets(record["path"], data)
            if len(data) != record["bytes"] or hashlib.sha256(data).hexdigest() != record["sha256"]:
                raise PackagingError(f"Manifest integrity mismatch: {record['path']}")
        if archive.testzip() is not None:
            raise PackagingError("Archive CRC verification failed.")
        return {"files": len(records), "source_bytes": sum(record["bytes"] for record in records)}


def package_sources(root: Path, output: Path, dry_run: bool = False) -> dict[str, object]:
    root = root.resolve(strict=True)
    output = output.resolve()
    if not output.is_relative_to(root) or ".git" in (part.casefold() for part in output.relative_to(root).parts):
        raise PackagingError("Output must stay inside the studio, outside .git metadata.")
    if output.suffix.casefold() != ".zip":
        raise PackagingError("Output filename must end in .zip.")
    if output.exists() or output.is_symlink():
        raise PackagingError("Output already exists; overwriting is refused.")
    names, excluded = inventory(root)
    records: list[dict[str, object]] = []
    fingerprints: dict[str, tuple[int, int]] = {}
    for name in names:
        data, information = read_source(root, name)
        records.append({"path": name, "bytes": len(data), "sha256": hashlib.sha256(data).hexdigest()})
        fingerprints[name] = (information.st_size, information.st_mtime_ns)
    summary: dict[str, object] = {
        "files": len(records), "source_bytes": sum(record["bytes"] for record in records),
        "excluded_candidates": len(excluded), "dry_run": dry_run,
    }
    if dry_run:
        return summary
    manifest = {
        "schema_version": 1,
        "created_at_utc": datetime.now(timezone.utc).isoformat(),
        "scope": "Raw working-tree bytes from Git cached and non-ignored untracked paths; not a Git-history archive.",
        "git_commit": git_query(root, "rev-parse", "--verify", "HEAD", allow_failure=True).decode().strip() or None,
        "git_branch": git_query(root, "symbolic-ref", "--short", "-q", "HEAD", allow_failure=True).decode().strip() or None,
        "working_tree_dirty": bool(git_query(root, "status", "--porcelain", "-z")),
        "files": records,
        "excluded_candidates": excluded,
        "secret_scan_limit": "Known raw-byte patterns only; compressed or encoded content still requires its prior review.",
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    created_identity: tuple[int, int] | None = None
    try:
        with output.open("xb") as stream:
            identity = os.fstat(stream.fileno())
            created_identity = (identity.st_dev, identity.st_ino)
            with zipfile.ZipFile(stream, "w", compression=zipfile.ZIP_DEFLATED, compresslevel=6, allowZip64=True) as archive:
                for record in records:
                    name = str(record["path"])
                    data, _information = read_source(root, name)
                    if hashlib.sha256(data).hexdigest() != record["sha256"]:
                        raise PackagingError(f"Source changed after preflight: {name}")
                    archive.writestr(name, data)
                if inventory(root)[0] != names:
                    raise PackagingError("The source inventory changed while packaging; retry after edits finish.")
                for name in names:
                    information = source_path(root, name).stat()
                    if (information.st_size, information.st_mtime_ns) != fingerprints[name]:
                        raise PackagingError(f"Source changed while packaging: {name}")
                archive.writestr(MANIFEST_NAME, json.dumps(manifest, ensure_ascii=False, indent=2).encode("utf-8") + b"\n")
        verify_archive(output)
    except Exception:
        # Delete only the new file opened exclusively by this invocation, never a prior output.
        if created_identity is not None and output.exists() and not output.is_symlink():
            current = output.stat()
            if (current.st_dev, current.st_ino) == created_identity and output.resolve().is_relative_to(root):
                output.unlink()
        raise
    summary["archive_bytes"] = output.stat().st_size
    summary["archive_sha256"] = hashlib.sha256(output.read_bytes()).hexdigest()
    return summary


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--output", type=Path, help="New .zip path, relative to the studio root or absolute within it")
    mode.add_argument("--verify", type=Path, help="Verify an archive without extracting it")
    parser.add_argument("--dry-run", action="store_true", help="Inspect sources without creating the requested output")
    arguments = parser.parse_args()
    root = Path(__file__).resolve().parents[3]
    try:
        if arguments.verify:
            if arguments.dry_run:
                parser.error("--dry-run is used with --output only")
            archive = arguments.verify if arguments.verify.is_absolute() else root / arguments.verify
            result: dict[str, object] = {"verified": True, **verify_archive(archive)}
        else:
            output = arguments.output if arguments.output.is_absolute() else root / arguments.output
            result = package_sources(root, output, arguments.dry_run)
        print(json.dumps(result, ensure_ascii=False, indent=2))
        return 0
    except (OSError, PackagingError, ValueError, KeyError, TypeError, zipfile.BadZipFile) as error:
        print(f"ERROR: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
