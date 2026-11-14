#!/usr/bin/env python3
"""Paired native captures of the unchanged level, on the studio's dedicated AVD."""
from __future__ import annotations

import argparse
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import re
import subprocess
import time

import verify_android_slice as p


def check_guidance(label: str, expected: str) -> None:
    if label != "after":
        return
    def latest():
        lines = [line.split("SLICE_GUIDANCE_LAYOUT ", 1)[1] for line in p.logs().splitlines() if "SLICE_GUIDANCE_LAYOUT " in line]
        if not lines:
            return None
        current = json.loads(lines[-1])
        return current if current.get("guidance", {}).get("state") == expected else None
    current = p.until(latest)
    guidance = current["guidance"]
    x, y, width, height = guidance["rect"]
    minimum = guidance["minimum_size"]
    logical = current["logical_viewport"]
    p.check("native instruction visible and bounded: " + expected,
            guidance["visible"] and 1 <= guidance["lines"] <= 2
            and guidance["visible_lines"] == guidance["lines"] and height <= 54
            and minimum[0] <= width + 1 and minimum[1] <= height + 1
            and x >= 0 and y >= 0 and x + width <= logical[0] + 1
            and y + height <= logical[1] + 1, guidance)


def run(apk: Path, label: str) -> None:
    stamp = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")
    base = p.GAME / "artifacts/polish" / f"android-{label}-{stamp}"
    base.mkdir(parents=True, exist_ok=False)
    p.OUT = base
    p.check("dedicated AVD", p.adb("emu", "avd", "name").splitlines()[0] == p.AVD)
    badging = p.native([str(p.SDK / "build-tools/36.1.0/aapt.exe"), "dump", "badging", str(apk)]).decode("utf-8")
    p.check("only studio package", f"package: name='{p.PACKAGE}'" in badging)
    apk_hash = hashlib.sha256(apk.read_bytes()).hexdigest()
    original = p.adb("shell", "wm", "size")
    override = re.search(r"Override size:\s*(\d+x\d+)", original)
    restore = override.group(1) if override else "reset"
    p.REPORT.update(label=label, apk_sha256=apk_hash, apk_bytes=apk.stat().st_size,
                    original_display=original, density=p.adb("shell", "wm", "density"), profiles=[])
    record = None
    record_file = None
    try:
        p.check("install only this APK", "Success" in p.adb("install", "-r", str(apk)))
        activity = p.adb("shell", "cmd", "package", "resolve-activity", "--brief", p.PACKAGE).splitlines()[-1]
        p.check("resolved own activity", activity.startswith(p.PACKAGE + "/"))
        p.REPORT["activity"] = activity
        level = json.loads((p.GAME / "data/archipel_double_flux.json").read_text(encoding="utf-8"))
        for width, height in [(1080, 2400), (720, 1280), (1200, 1600)]:
            name = f"{width}x{height}"
            p.OUT = base / name
            p.OUT.mkdir()
            p.adb("shell", "am", "force-stop", p.PACKAGE)
            p.adb("shell", "wm", "size", name)
            p.launch()
            p.check(name + " native dimensions", p.layout()["window"] == [width, height])
            p.pause()
            p.options(False, False)
            p.tap("buttons", "restart")
            p.until(lambda: p.saved()["rotations"] == p.saved()["attempts"] == 0)
            check_guidance(label, "fresh")
            p.capture("planning")
            p.snapshot("planning")
            cursor = len(p.logs())
            p.tap("buttons", "dispatch")
            p.wait_event("SLICE_RESULT success=false", cursor)
            p.capture("failed")
            if width == 1080:
                remote = f"/sdcard/Movies/studio100-polish-{label}-{stamp}.mp4"
                record_file = (p.OUT / "screenrecord.log").open("wb")
                record = subprocess.Popen(p.ADB + ["shell", "screenrecord", "--time-limit", "10", "--size", "1080x2400", "--bit-rate", "10000000", remote], env=p.ENV, stdout=record_file, stderr=subprocess.STDOUT)
                time.sleep(0.35)
                p.tap("cells", 8)
                p.tap("buttons", "undo")
            p.solve(level)
            p.capture("prepared")
            prepared = p.saved()
            p.check(name + " six witness rotations", prepared["rotations"] == 6 and prepared["attempts"] == 1)
            cursor = len(p.logs())
            p.tap("buttons", "dispatch", 0.12)
            time.sleep(0.35)
            p.capture("transport")
            check_guidance(label, "running")
            p.wait_event("SLICE_RESULT success=true", cursor)
            time.sleep(0.65)
            p.capture("won")
            won = p.snapshot("won")
            p.check(name + " genuine two-delivery result", won["rotations"] == 6 and won["attempts"] == 2)
            if label == "after":
                p.check(name + " both local receipts completed", all("SLICE_RECEIVED address=" + a in p.logs()[cursor:] for a in ["A", "B"]))
            if record is not None:
                record.wait(timeout=12)
                record_file.close()
                p.check("native movie recording", record.returncode == 0)
                p.adb("pull", remote, str(p.OUT / "arrivals.mp4"))
                record = None
            (p.OUT / f"app-{p.PID}-play.log").write_text(p.logs(), encoding="utf-8")
            p.adb("shell", "am", "force-stop", p.PACKAGE)
            p.launch()
            p.check(name + " restored preparation unchanged", p.saved() == won)
            check_guidance(label, "restored_ready")
            p.capture("restored")
            # A fresh process gives a comparable idle-only interval window.
            time.sleep(11)
            metric_lines = [line.split("SLICE_METRICS ", 1)[1] for line in p.logs().splitlines() if "SLICE_METRICS " in line]
            p.check(name + " idle metrics recorded", bool(metric_lines))
            metrics = json.loads(metric_lines[-1])
            memory = p.adb("shell", "dumpsys", "meminfo", p.PACKAGE)
            (p.OUT / "memory.log").write_text(memory, encoding="utf-8")
            pss = re.search(r"TOTAL PSS:\s*(\d+)", memory)
            p.REPORT["profiles"].append({"pixels": [width, height], "idle_seconds": 11,
                                        "metrics": metrics, "pss_kib": int(pss.group(1)) if pss else None})
            # Existing reduced-motion preference, same level and same witness.
            if width == 1080:
                p.pause()
                p.options(True, False)
                p.tap("buttons", "restart")
                p.solve(level)
                cursor = len(p.logs())
                p.tap("buttons", "dispatch")
                p.wait_event("SLICE_RESULT success=true", cursor)
                p.capture("won-reduced")
                p.check("reduced motion preserves witness", p.saved()["ports"] == won["ports"])
            p.pause()
            p.options(False, False)
            p.tap("buttons", "restart")
            app_log = p.logs()
            errors = [line for line in app_log.splitlines() if re.search(r"SCRIPT ERROR:|\bERROR:|FATAL EXCEPTION", line)]
            p.check(name + " no Godot or fatal error", not errors, errors)
            (p.OUT / f"app-{p.PID}-restored.log").write_text(app_log, encoding="utf-8")
        p.check("APK unchanged during comparisons", hashlib.sha256(apk.read_bytes()).hexdigest() == apk_hash)
        p.REPORT["status"] = "passed"
    except Exception as error:
        p.REPORT.update(status="failed", error=str(error))
        raise
    finally:
        try:
            if record is not None:
                try:
                    record.wait(timeout=12)
                except subprocess.TimeoutExpired:
                    p.REPORT.update(status="failed", recorder_error="Recorder did not terminate within its time limit")
                    record.terminate()  # Only this invocation's recording subprocess.
                    record.wait(timeout=5)
                finally:
                    record_file.close()
        finally:
            # Display restoration and its receipt must also run if recorder cleanup fails.
            try:
                p.adb("shell", "am", "force-stop", p.PACKAGE)
                p.adb("shell", "wm", "size", restore)
                p.OUT = base
                p.launch()
                p.check("original display restored", p.adb("shell", "wm", "size") == original)
            except Exception as error:
                p.REPORT.update(status="failed", restore_error=str(error))
                raise
            finally:
                (base / "receipt.json").write_text(json.dumps(p.REPORT, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
                print(base, flush=True)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--label", choices=["before", "after"], required=True)
    parser.add_argument("--apk", type=Path, required=True)
    arguments = parser.parse_args()
    run(arguments.apk.resolve(strict=True), arguments.label)
