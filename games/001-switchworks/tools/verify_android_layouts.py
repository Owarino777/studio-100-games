#!/usr/bin/env python3
"""Check two display ratios on the dedicated AVD and restore its prior wm size."""
from __future__ import annotations

from datetime import datetime, timezone
import json
from pathlib import Path
import re

import verify_android_slice as probe


def main() -> None:
    probe.OUT = probe.GAME / "artifacts/slice-android" / ("layouts-" + datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ"))
    probe.OUT.mkdir(parents=True, exist_ok=False)
    probe.check("dedicated AVD identity", probe.adb("emu", "avd", "name").splitlines()[0] == probe.AVD)
    original = probe.adb("shell", "wm", "size")
    override = re.search(r"Override size:\s*(\d+x\d+)", original)
    restore = override.group(1) if override else "reset"
    probe.REPORT.update(original_display=original, original_density=probe.adb("shell", "wm", "density"), profiles=[])
    activity = probe.adb("shell", "cmd", "package", "resolve-activity", "--brief", probe.PACKAGE).splitlines()[-1]
    probe.check("launcher belongs to slice", activity.startswith(probe.PACKAGE + "/"))
    probe.REPORT["activity"] = activity
    baseline = probe.saved()
    try:
        for width, height in [(720, 1280), (1200, 1600)]:
            tag = f"{width}x{height}"
            probe.adb("shell", "am", "force-stop", probe.PACKAGE)
            probe.adb("shell", "wm", "size", tag)
            probe.launch()
            current = probe.layout()
            probe.check(f"{tag} renderer uses display dimensions", current["window"] == [width, height], current)
            probe.check(f"{tag} all 36 projected centers inside", len(current["cells"]) == 36 and all(0 <= x < width and 0 <= y < height for x, y in current["cells"].values()))
            before = probe.saved()
            probe.tap("cells", 8)
            probe.until(lambda: probe.saved()["rotations"] == before["rotations"] + 1)
            probe.tap("buttons", "undo")
            probe.until(lambda: probe.saved() == before)
            probe.check(f"{tag} touch and undo preserve preparation", probe.saved() == baseline)
            probe.capture(f"{tag}-planning")
            probe.pause()
            probe.capture(f"{tag}-paused")
            probe.tap("buttons", "resume")
            app_log = probe.logs()
            bad = [line for line in app_log.splitlines() if re.search(r"SCRIPT ERROR:|\bERROR:|FATAL EXCEPTION", line)]
            probe.check(f"{tag} no Godot script or fatal errors", not bad, bad)
            (probe.OUT / f"app-{tag}.log").write_text(app_log, encoding="utf-8")
            probe.REPORT["profiles"].append({"pixels": [width, height], "layout": current, "pid": probe.PID})
        probe.REPORT["status"] = "passed"
    except Exception as error:
        probe.REPORT.update(status="failed", error=str(error))
        raise
    finally:
        try:
            probe.adb("shell", "am", "force-stop", probe.PACKAGE)
            probe.adb("shell", "wm", "size", restore)
            probe.launch()
            probe.check("original display override restored", probe.adb("shell", "wm", "size") == original)
            probe.check("saved preparation unchanged", probe.saved() == baseline)
            probe.capture("restored-display")
        except Exception as error:
            probe.REPORT.update(status="failed", restore_error=str(error))
            raise
        finally:
            (probe.OUT / "receipt.json").write_text(json.dumps(probe.REPORT, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
            print(probe.OUT)


if __name__ == "__main__":
    main()
