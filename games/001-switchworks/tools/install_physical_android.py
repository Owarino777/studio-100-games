#!/usr/bin/env python3
"""Inspect/install the frozen APK on an explicitly selected physical ARM64 Android."""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import struct
import subprocess
import zipfile

GAME = Path(__file__).resolve().parents[1]
APK = GAME / "build/android/switchworks-archipel-polish-debug.apk"
SHA256 = "6f3b3853bda59dbde4697814aa5afe547f37e7513408ce0d6a719c194769e965"
PACKAGE = "org.studio100games.switchworks.archipel.slice"
VERSION_CODE = 6
REFERENCE = "108e2b04a3109f8f67d00a65caf0d60d7f1c979e"
ACTIVITY = PACKAGE + "/com.godot.game.GodotAppLauncher"


class CheckError(RuntimeError):
    pass


def sdk_adb() -> Path:
    for variable in ["ANDROID_HOME", "ANDROID_SDK_ROOT"]:
        if os.environ.get(variable):
            candidate = Path(os.environ[variable]) / "platform-tools/adb.exe"
            if candidate.is_file():
                return candidate
    candidate = Path(os.environ.get("LOCALAPPDATA", "")) / "Android/Sdk/platform-tools/adb.exe"
    if not candidate.is_file():
        raise CheckError("ADB absent : utiliser le SDK existant, sans installation automatique.")
    return candidate


def verify_apk(path: Path) -> dict:
    if not path.is_file():
        raise CheckError("APK absent. Utiliser le fichier de reference existant, sans reconstruire le jeu.")
    data = path.read_bytes()
    if hashlib.sha256(data).hexdigest() != SHA256:
        raise CheckError("SHA256 different de la reference : installation refusee.")
    libraries = []
    with zipfile.ZipFile(path) as archive:
        if archive.testzip() is not None:
            raise CheckError("Archive APK corrompue.")
        for name in archive.namelist():
            if name.startswith("lib/arm64-v8a/") and name.endswith(".so"):
                header = archive.read(name)[:20]
                if header[:6] != b"\x7fELF\x02\x01" or struct.unpack_from("<H", header, 18)[0] != 183:
                    raise CheckError("Bibliotheque ARM64 invalide.")
                libraries.append(name)
    if not libraries:
        raise CheckError("Aucune bibliotheque ARM64 embarquee.")
    # Exact hash binds these audited metadata and public-signature checks to this APK.
    return {"sha256": SHA256, "bytes": len(data), "package": PACKAGE,
            "version_code": VERSION_CODE, "version_name": "0.1.1-polish.4",
            "minimum_api": 24, "minimum_gles": "3.0", "arm64_libraries": libraries,
            "reference_commit": REFERENCE, "signature_scope": "identical to previously audited APK; hash checked here"}


def native(arguments: list[str], timeout: int = 25, allow_empty_not_found: bool = False) -> str:
    environment = os.environ.copy()
    environment.pop("ADB_SERVER_SOCKET", None)
    result = subprocess.run(arguments, env=environment, capture_output=True, timeout=timeout)
    output = result.stdout.decode("utf-8", errors="replace").strip()
    error_output = result.stderr.decode("utf-8", errors="replace").strip()
    if result.returncode:
        # pm path may return exit 1 with no text for a package not installed yet.
        if allow_empty_not_found and result.returncode == 1 and not output and not error_output:
            return ""
        raise CheckError("Commande ADB refusee : " + "\n".join(x for x in [output, error_output] if x))
    return output


def devices(adb: list[str]) -> list[dict]:
    entries = []
    for line in native(adb + ["devices", "-l"]).splitlines():
        fields = line.split()
        if len(fields) >= 2 and not line.startswith(("List of devices", "*")):
            entries.append({"serial": fields[0], "state": fields[1]})
    return entries


def physical_device(adb: list[str], serial: str, entries: list[dict]) -> tuple[list[str], dict]:
    selected = [entry for entry in entries if entry["serial"] == serial]
    if len(selected) != 1 or selected[0]["state"] != "device":
        raise CheckError("Appareil absent, offline ou unauthorized : deverrouiller et autoriser manuellement le PC.")
    target = adb + ["-s", serial]
    def prop(key: str) -> str:
        return native(target + ["shell", "getprop", key])
    hardware, model = prop("ro.hardware"), prop("ro.product.model")
    if (serial.startswith("emulator-") or prop("ro.kernel.qemu") == "1"
            or prop("ro.boot.qemu") == "1" or hardware.lower() in {"ranchu", "goldfish"}
            or model.lower().startswith(("sdk_gphone", "android sdk"))):
        raise CheckError("Emulateur refuse : cette passation exige un telephone physique.")
    abis = prop("ro.product.cpu.abilist").split(",")
    if "arm64-v8a" not in abis:
        raise CheckError("Telephone sans ABI arm64-v8a : installation refusee.")
    try:
        api, gles = int(prop("ro.build.version.sdk")), int(prop("ro.opengles.version"))
    except ValueError as error:
        raise CheckError("API/GLES non verifiables : arret sans modification.") from error
    if api < 24 or gles < 196608:
        raise CheckError("Prerequis insuffisants : API24 minimum et GLES3.0 requis.")
    return target, {"model": model, "api": api, "abis": abis, "reported_gles_integer": gles,
                    "serial_digest": hashlib.sha256(serial.encode()).hexdigest()[:12],
                    "physical_metadata_checked": True, "rendering_and_human_usability": "not tested"}


def installed_package(target: list[str]) -> dict | None:
    paths = native(target + ["shell", "pm", "path", PACKAGE], allow_empty_not_found=True).splitlines()
    if not paths:
        return None
    if len(paths) != 1 or not paths[0].startswith("package:"):
        raise CheckError("APK installe non unique/splits inattendus : verifier sans effacer les donnees.")
    path = paths[0][len("package:"):]
    if (not re.fullmatch(r"/data/app/[A-Za-z0-9_~./+=-]+/base\.apk", path)
            or ".." in PurePosixPath(path).parts):
        raise CheckError("Chemin APK distant non reconnu : aucun acces arbitraire.")
    text = native(target + ["shell", "dumpsys", "package", PACKAGE])
    match = re.search(r"\bversionCode=(\d+)\b", text)
    if match is None:
        raise CheckError("Package present mais version non verifiable : arret sans modification.")
    checksum = native(target + ["shell", "sha256sum", path]).split()
    if len(checksum) != 2 or not re.fullmatch(r"[0-9a-fA-F]{64}", checksum[0]) or checksum[1] != path:
        raise CheckError("Empreinte APK distant non verifiable : arret sans lancer.")
    return {"version_code": int(match.group(1)), "sha256": checksum[0].lower()}


def execute(args: argparse.Namespace, report: dict) -> None:
    report["apk"] = verify_apk(args.apk.resolve())
    adb = [str(sdk_adb()), "-P", str(args.port)]
    entries = devices(adb)
    # Serial is displayed only for deliberate local selection; receipts omit raw identifiers.
    if args.action == "inspect":
        print(json.dumps({"connected_devices": entries}, ensure_ascii=False, indent=2))
        report.update(status="inspected", connected_count=len(entries), installation="not attempted")
        if not args.serial:
            return
    if not args.serial:
        raise CheckError("--serial obligatoire pour installer ou lancer ; aucune selection automatique.")
    target, info = physical_device(adb, args.serial, entries)
    report["device"] = info
    previous = installed_package(target)
    version = previous["version_code"] if previous else None
    report["previous_version_code"] = version
    report["previous_apk_sha256"] = previous["sha256"] if previous else None
    if version is not None and version > VERSION_CODE:
        raise CheckError("Version plus recente deja installee : aucun downgrade ni effacement.")
    if args.action == "install":
        output = native(target + ["install", "-r", str(args.apk.resolve())], timeout=120)
        installed = installed_package(target)
        if "Success" not in output or installed != {"version_code": VERSION_CODE, "sha256": SHA256}:
            raise CheckError("Installation non confirmee. Ne pas desinstaller/effacer pour contourner un conflit de signature.")
        report.update(installation="confirmed", installed_version_code=VERSION_CODE, installed_apk_sha256=SHA256)
    elif args.action == "launch":
        if previous != {"version_code": VERSION_CODE, "sha256": SHA256}:
            raise CheckError("Installer d'abord la version de reference sur ce telephone.")
        resolved_lines = native(target + ["shell", "cmd", "package", "resolve-activity", "--brief", PACKAGE]).splitlines()
        if resolved_lines != [ACTIVITY]:
            raise CheckError("Activite de reference non resolue.")
        result = native(target + ["shell", "am", "start", "-W", "-n", ACTIVITY])
        if "Status: ok" not in result:
            raise CheckError("Lancement non confirme ; observer le telephone et conserver l'anomalie.")
        report["launch"] = "activity start confirmed; visual launch and gameplay still need observation"
    report["status"] = "completed" if args.action != "inspect" else "inspected"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("action", choices=["inspect", "install", "launch"], nargs="?", default="inspect")
    parser.add_argument("--serial", help="Exact local ADB identifier; never selected automatically")
    parser.add_argument("--apk", type=Path, default=APK)
    parser.add_argument("--port", type=int, default=5037)
    args = parser.parse_args()
    if not 1 <= args.port <= 65535:
        parser.error("invalid ADB port")
    report = {"date_utc": datetime.now(timezone.utc).isoformat(), "action": args.action,
              "human_test_status": "NOT_EXECUTED", "reference_commit": REFERENCE,
              "data_policy": "no clear/uninstall/downgrade, no touch injection, no network pairing"}
    exit_code = 0
    try:
        execute(args, report)
    except (CheckError, OSError, subprocess.TimeoutExpired, zipfile.BadZipFile) as error:
        message = str(error).replace(args.serial, "[selected-device]") if args.serial else str(error)
        report.update(status="blocked", error=message)
        exit_code = 2
    folder = GAME / "artifacts/user-tests"
    folder.mkdir(parents=True, exist_ok=True)
    receipt = folder / ("physical-install-" + datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ") + ".json")
    receipt.write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(json.dumps(report, ensure_ascii=False, indent=2))
    print("Local receipt:", receipt)
    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())
