#!/usr/bin/env python3
"""Prepare or locally zip the review kit; never publish, commit, or change gameplay."""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path
import shutil
import subprocess
import zipfile

ROOT = Path(__file__).resolve().parents[3]
GAME = ROOT / "games/001-switchworks"
KIT = GAME / "docs/stabilization/review-kit"
BRANCH = "feat/archipel-postal-vertical-slice"
APK_SHA = "7112e363b030f75dc549a70f26d7d75ff88b7eccda4fa2aa660229abc4b394b1"
MAIN_SHA = "68548a4b004a047e43d9ce0c77f248ffc07af23d"
COPIES = {
    "media/01-entree-preparation.png": "games/001-switchworks/docs/vertical-slice/evidence/android/planning.png",
    "media/02-gameplay.png": "games/001-switchworks/docs/vertical-slice/evidence/android/in-motion.png",
    "media/03-reussite.png": "games/001-switchworks/docs/vertical-slice/evidence/android/won.png",
    "media/04-gameplay-android.mp4": "games/001-switchworks/docs/vertical-slice/evidence/android/android-gameplay.mp4",
    "annexe/reprise-preparation.png": "games/001-switchworks/docs/vertical-slice/evidence/android/restored-preparation.png",
    "reference/B-concept.png": "docs/art/switchworks/concepts/b-archipel-postal-v3.png",
    "GRILLE_REVUE.csv": "games/001-switchworks/docs/stabilization/EXTERNAL_REVIEW_GRID.csv",
}


def digest(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def git(*args: str) -> str:
    environment = os.environ.copy()
    for key in ("GIT_DIR", "GIT_WORK_TREE", "GIT_INDEX_FILE", "GIT_COMMON_DIR",
                "GIT_OBJECT_DIRECTORY", "GIT_ALTERNATE_OBJECT_DIRECTORIES"):
        environment.pop(key, None)
    return subprocess.check_output(
        ["git", "-c", f"safe.directory={ROOT.as_posix()}", "-C", str(ROOT), *args],
        timeout=30, env=environment,
    ).decode("utf-8").strip()


def files() -> list[Path]:
    if not KIT.resolve().is_relative_to(ROOT.resolve()):
        raise ValueError("Review kit resolves outside the studio")
    selected = sorted(p for p in KIT.rglob("*") if p.is_file())
    for path in selected:
        if path.is_symlink() or not path.resolve().is_relative_to(KIT.resolve()):
            raise ValueError("Review sources must be regular files inside the kit")
    return selected


def verify_kit() -> dict:
    provenance = json.loads((KIT / "PROVENANCE.json").read_text(encoding="utf-8"))
    expected = {r["path"] for r in provenance["files"]} | {"PROVENANCE.json"}
    if {p.relative_to(KIT).as_posix() for p in files()} != expected:
        raise ValueError("Kit inventory differs from PROVENANCE.json; prepare it again")
    for record in provenance["files"]:
        data = (KIT / record["path"]).read_bytes()
        if len(data) != record["bytes"] or digest(data) != record["sha256"]:
            raise ValueError("Kit hash mismatch: " + record["path"])
    return provenance


def prepare() -> None:
    for target, source in COPIES.items():
        data, destination = (ROOT / source).read_bytes(), KIT / target
        destination.parent.mkdir(parents=True, exist_ok=True)
        if destination.exists():
            if destination.read_bytes() != data:
                raise ValueError("Refusing to overwrite a different proof: " + target)
        else:
            shutil.copy2(ROOT / source, destination)
    records = []
    for path in files():
        name = path.relative_to(KIT).as_posix()
        if name == "PROVENANCE.json":
            continue
        data = path.read_bytes()
        records.append({"path": name, "bytes": len(data), "sha256": digest(data),
                        "original_source": COPIES.get(name),
                        "unchanged_copy": True if name in COPIES else None})
    provenance = {"schema_version": 1, "status": "TEST / HOLD, no human acceptance yet",
                  "apk_sha256": APK_SHA, "engine": "Godot4.7.2 Standard ed1daf0bf",
                  "scene": "res://scenes/archipel_postal.tscn",
                  "capture_platform": "Studio_API_36 Android16 API36 x86_64; 1080x2400, video720x1600",
                  "entry_screen": "Direct preparation, no separate home menu",
                  "media_processing": "Original PNG/MP4 copies; no cropping, retouching, resizing or re-encoding",
                  "git_reference": "REFERENCE_GIT.txt is added to the ZIP after the local reference commit",
                  "files": records}
    (KIT / "PROVENANCE.json").write_text(json.dumps(provenance, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    verify_kit()
    print(json.dumps({"prepared": True, "files": len(records) + 1, "bytes": sum(r["bytes"] for r in records)}))


def bundle(output: Path) -> None:
    if git("branch", "--show-current") != BRANCH or git("rev-parse", "refs/heads/main") != MAIN_SHA:
        raise ValueError("Expected slice branch and unchanged main")
    if git("status", "--porcelain"):
        raise ValueError("Commit and verify the review sources before bundling")
    verify_kit()
    output = output.resolve()
    if (not output.is_relative_to(ROOT.resolve())
            or not output.is_relative_to((GAME / "build/delivery").resolve())
            or output.suffix != ".zip"):
        raise ValueError("Output must be a new ZIP inside this game's build/delivery")
    if output.exists():
        raise ValueError("Refusing to overwrite an existing archive")
    commit = git("rev-parse", "HEAD")
    tracked = set(git("ls-files", "-z", "--", KIT.relative_to(ROOT).as_posix()).split("\0"))
    if any(p.relative_to(ROOT).as_posix() not in tracked for p in files()):
        raise ValueError("Every review source must be tracked by the reference commit")
    contents = {p.relative_to(KIT).as_posix(): p.read_bytes() for p in files()}
    contents["REFERENCE_GIT.txt"] = (
        f"Branch: {BRANCH}\nReference commit: {commit}\nUnchanged main: {MAIN_SHA}\n"
        f"APK SHA256: {APK_SHA}\nStatus: TEST / HOLD; no human or commercial approval\n"
    ).encode("utf-8")
    manifest = {"schema_version": 1, "reference_commit": commit,
                "created_at_utc": datetime.now(timezone.utc).isoformat(),
                "files": [{"path": n, "bytes": len(b), "sha256": digest(b)} for n, b in sorted(contents.items())]}
    contents["ZIP_MANIFEST.json"] = (json.dumps(manifest, indent=2) + "\n").encode("utf-8")
    output.parent.mkdir(parents=True, exist_ok=True)
    with output.open("xb") as stream:
        with zipfile.ZipFile(stream, "w", zipfile.ZIP_DEFLATED, compresslevel=6) as archive:
            for name, data in sorted(contents.items()):
                archive.writestr(name, data)
    with zipfile.ZipFile(output) as archive:
        if (archive.testzip() is not None or set(archive.namelist()) != set(contents)
                or any(archive.read(name) != data for name, data in contents.items())):
            raise ValueError("Review archive content verification failed")
    print(json.dumps({"verified": True, "commit": commit, "files": len(contents),
                      "archive_bytes": output.stat().st_size, "archive_sha256": digest(output.read_bytes())}, indent=2))


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=["prepare", "bundle"])
    parser.add_argument("--output", type=Path)
    args = parser.parse_args()
    try:
        if args.action == "prepare":
            prepare()
        else:
            if args.output is None:
                parser.error("bundle requires --output")
            bundle(args.output if args.output.is_absolute() else ROOT / args.output)
    except (OSError, ValueError, subprocess.CalledProcessError) as error:
        raise SystemExit("Review packaging failed: " + str(error)) from error
