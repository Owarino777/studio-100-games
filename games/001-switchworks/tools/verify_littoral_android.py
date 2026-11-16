#!/usr/bin/env python3
"""Exercise the isolated art-study APK on the dedicated studio AVD only."""
from __future__ import annotations
import hashlib
import json
from pathlib import Path
import re
import subprocess
import time
from datetime import datetime, timezone
import verify_android_slice as p

PACKAGE = "org.studio100games.switchworks.littoral.study"


def saved() -> dict:
    if not p.SAVE_FILE:
        matches = p.adb("shell", "run-as", PACKAGE, "find", "files", "-name", "littoral_composition_v1.json").splitlines()
        if len(matches) != 1 or not matches[0].startswith("files/") or ".." in Path(matches[0]).parts:
            raise FileNotFoundError("Study preparation not yet saved")
        p.SAVE_FILE = matches[0]
    try:
        return json.loads(p.adb("shell", "run-as", PACKAGE, "cat", p.SAVE_FILE))
    except subprocess.CalledProcessError:
        p.SAVE_FILE = ""
        raise


def run() -> None:
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")
    base = p.GAME / "artifacts/art-study-2026-11-16" / ("android-" + stamp)
    base.mkdir(parents=True)
    p.PACKAGE = PACKAGE
    p.saved = saved
    p.OUT = base
    p.REPORT = {"context": "ANDROID_EMULATOR_NOT_PHYSICAL", "package": PACKAGE, "serial": p.SERIAL,
                "avd": p.AVD, "adb_server_port": int(p.PORT), "checks": [], "profiles": []}
    apk = p.GAME / "build/android/switchworks-littoral-study-debug.apk"
    original = p.adb("shell", "wm", "size")
    override = re.search(r"Override size:\s*(\d+x\d+)", original)
    restore = override.group(1) if override else "reset"
    record = None
    stream = None
    try:
        p.check("dedicated studio AVD", p.adb("emu", "avd", "name").splitlines()[0] == p.AVD)
        badging = p.native([str(p.SDK / "build-tools/36.1.0/aapt.exe"), "dump", "badging", str(apk)]).decode("utf-8")
        p.check("only isolated study package", f"package: name='{PACKAGE}'" in badging)
        p.REPORT.update(apk_sha256=hashlib.sha256(apk.read_bytes()).hexdigest(), apk_bytes=apk.stat().st_size,
                        original_display=original, density=p.adb("shell", "wm", "density"),
                        android_api=p.adb("shell", "getprop", "ro.build.version.sdk"), gpu_backend="host")
        p.check("install study, never replace polish APK", "Success" in p.adb("install", "-r", str(apk)))
        activity = p.adb("shell", "cmd", "package", "resolve-activity", "--brief", PACKAGE).splitlines()[-1]
        p.check("activity belongs to study", activity.startswith(PACKAGE + "/"))
        p.REPORT["activity"] = activity
        level = json.loads((p.GAME / "data/archipel_double_flux.json").read_text(encoding="utf-8"))
        for index, size in enumerate(["1080x2340", "720x1280"]):
            p.OUT = base / size
            p.OUT.mkdir()
            p.adb("shell", "am", "force-stop", PACKAGE)
            p.adb("shell", "wm", "size", size)
            p.SAVE_FILE = ""
            p.launch()
            p.pause()
            p.options(False, False)
            p.tap("buttons", "restart")
            p.until(lambda: saved()["rotations"] == saved()["attempts"] == 0)
            initial = p.snapshot("initial")
            p.capture("planning")
            p.tap("cells", 8)
            p.until(lambda: saved()["rotations"] == 1)
            p.check(size + " one tap, one rotation", saved()["rotations"] == 1)
            p.tap("buttons", "undo")
            p.check(size + " undo restores ports", saved()["ports"] == initial["ports"])
            source = level["sources"]["A"]
            p.tap("cells", int(source[0]) * int(level["grid_size"]) + int(source[1]))
            p.check(size + " source remains fixed", saved()["rotations"] == 0)
            cursor = len(p.logs())
            p.tap("buttons", "dispatch")
            p.wait_event("SLICE_RESULT success=false", cursor)
            p.capture("failed")
            p.pause()
            p.tap("buttons", "restart")
            if index == 0:
                remote = "/sdcard/studio_littoral_" + stamp + ".mp4"
                stream = (p.OUT / "screenrecord.log").open("wb")
                record = subprocess.Popen(p.ADB + ["shell", "screenrecord", "--time-limit", "12", "--size", "720x1560", "--bit-rate", "6000000", remote], env=p.ENV, stdout=stream, stderr=subprocess.STDOUT)
                time.sleep(0.4)
            p.solve(level)
            p.snapshot("prepared")
            p.capture("prepared")
            cursor = len(p.logs())
            p.tap("buttons", "dispatch", 0.35)
            p.pause()
            p.capture("paused")
            time.sleep(0.3)
            p.tap("buttons", "resume")
            p.wait_event("SLICE_RESULT success=true", cursor)
            time.sleep(0.5)
            p.capture("won")
            p.check(size + " two real receptions", "SLICE_RECEIVED address=A" in p.logs()[cursor:] and "SLICE_RECEIVED address=B" in p.logs()[cursor:])
            if record is not None:
                record.wait(timeout=20)
                stream.close()
                stream = None
                p.check("screenrecord completed", record.returncode == 0)
                p.native(p.ADB + ["pull", remote, str(p.OUT / "android-gameplay.mp4")])
                record = None
            # Home/reload checks are separate from the recorded in-game sequence.
            p.pause()
            p.tap("buttons", "restart")
            p.tap("cells", 8)
            before = saved()["ports"]
            p.adb("shell", "input", "keyevent", "3")
            time.sleep(0.4)
            p.adb("shell", "am", "start", "-n", activity)
            p.until(lambda: p.layout()["phase"] == "paused")
            p.capture("home-return")
            p.tap("buttons", "resume")
            p.check(size + " Home preserves rotation", saved()["ports"] == before)
            active_logs = p.logs()
            (p.OUT / "session.log").write_text(active_logs, encoding="utf-8")
            observed_metrics = [json.loads(line.split("LITTORAL_PERF ", 1)[1]) for line in active_logs.splitlines() if "LITTORAL_PERF " in line]
            p.adb("shell", "am", "force-stop", PACKAGE)
            p.launch()
            p.check(size + " process restart restores preparation", saved()["ports"] == before)
            logs = p.logs()
            p.check(size + " runtime clean", not re.search(r"SCRIPT ERROR|(^|\s)ERROR:|FATAL EXCEPTION", logs))
            (p.OUT / "runtime.log").write_text(logs, encoding="utf-8")
            p.REPORT["profiles"].append({"display": size, "layout": p.layout(), "recording_influences_first_profile": index == 0, "observed_metrics": observed_metrics})
        p.REPORT["status"] = "passed"
    except Exception as error:
        p.REPORT["status"] = "failed"
        p.REPORT["error"] = str(error)
        raise
    finally:
        if record is not None and record.poll() is None:
            record.terminate()
            record.wait(timeout=10)
        if stream is not None: stream.close()
        if p.PID: (p.OUT / "all-available-runtime.log").write_text(p.logs(), encoding="utf-8")
        p.adb("shell", "wm", "size", restore)
        p.REPORT["restored_display"] = p.adb("shell", "wm", "size")
        (base / "receipt.json").write_text(json.dumps(p.REPORT, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print("Littoral Android receipt:", base, p.REPORT.get("status"), flush=True)


if __name__ == "__main__":
    run()
