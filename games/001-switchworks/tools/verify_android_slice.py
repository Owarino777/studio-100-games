#!/usr/bin/env python3
"""Exercise only the studio slice on its dedicated AVD; never clear application data."""
from __future__ import annotations

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import shlex
import subprocess
import time
from datetime import datetime, timezone

GAME = Path(__file__).resolve().parents[1]
ROOT = GAME.parents[1]
PACKAGE = "org.studio100games.switchworks.archipel.slice"
SERIAL, AVD, PORT = "emulator-5580", "Studio_API_36", "5041"
SDK = Path(os.environ.get("ANDROID_HOME", Path(os.environ["LOCALAPPDATA"]) / "Android/Sdk"))
ADB = [str(SDK / "platform-tools/adb.exe"), "-P", PORT, "-s", SERIAL]
ENV = {**os.environ, "ADB_SERVER_SOCKET": "tcp:127.0.0.1:5041", "ANDROID_ADB_SERVER_PORT": PORT,
       "ANDROID_HOME": str(SDK), "ANDROID_SDK_ROOT": str(SDK),
       "ANDROID_USER_HOME": str(ROOT / "tools/.local/android/user"),
       "ANDROID_EMULATOR_HOME": str(ROOT / "tools/.local/android/user"),
       "ANDROID_AVD_HOME": str(ROOT / "tools/.local/android/avd")}
PID, SAVE_FILE = "", ""
REPORT: dict = {"package": PACKAGE, "serial": SERIAL, "avd": AVD, "adb_server_port": int(PORT), "checks": []}
OUT: Path


def native(command: list[str], timeout: int = 30) -> bytes:
    return subprocess.run(command, env=ENV, check=True, capture_output=True, timeout=timeout).stdout


def adb(*arguments: str) -> str:
    return native(ADB + list(arguments)).decode("utf-8", errors="replace").strip()


def check(name: str, condition: bool, detail=None) -> None:
    REPORT["checks"].append({"name": name, "passed": bool(condition), "detail": detail})
    print(f"{name}: {'PASS' if condition else 'FAIL'}", flush=True)
    if not condition:
        raise RuntimeError(name)


def until(predicate, seconds: float = 12):
    deadline, last_error = time.monotonic() + seconds, None
    while time.monotonic() < deadline:
        try:
            value = predicate()
            if value:
                return value
        except (subprocess.CalledProcessError, json.JSONDecodeError, FileNotFoundError) as error:
            last_error = error
        time.sleep(0.12)
    raise TimeoutError(f"Observation did not arrive within {seconds}s: {last_error}")


def logs() -> str:
    return adb("logcat", f"--pid={PID}", "-d", "-v", "threadtime") if PID else ""


def wait_event(token: str, cursor: int) -> None:
    return until(lambda: token in logs()[cursor:])


def layout() -> dict:
    lines = [line.split("SLICE_LAYOUT ", 1)[1] for line in logs().splitlines() if "SLICE_LAYOUT " in line]
    return json.loads(lines[-1])


def tap(kind: str, key, delay: float = 0.25) -> None:
    current = layout()
    x, y = current[kind][str(key)]
    width, height = current["window"]
    check(f"target {kind}/{key} inside device", 0 <= x < width and 0 <= y < height, [x, y])
    adb("shell", "input", "tap", str(x), str(y))
    time.sleep(delay)


def saved() -> dict:
    global SAVE_FILE
    if not SAVE_FILE:
        matches = adb("shell", "run-as", PACKAGE, "find", "files", "-name", "archipel_slice_v1.json").splitlines()
        if not matches:
            raise FileNotFoundError("Application has not saved its preparation yet")
        if len(matches) != 1 or not matches[0].startswith("files/") or ".." in Path(matches[0]).parts:
            raise RuntimeError("Unexpected application save location")
        SAVE_FILE = matches[0]
    return json.loads(adb("shell", "run-as", PACKAGE, "cat", shlex.quote(SAVE_FILE)))


def snapshot(name: str) -> dict:
    state = saved()
    (OUT / f"state-{name}.json").write_text(json.dumps(state, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    return state


def capture(name: str) -> None:
    time.sleep(0.12)
    image = native(ADB + ["exec-out", "screencap", "-p"])
    check(f"capture {name} is PNG", image.startswith(b"\x89PNG\r\n\x1a\n"))
    (OUT / f"{name}.png").write_bytes(image)


def launch() -> str:
    global PID
    result = adb("shell", "am", "start", "-W", "-n", REPORT["activity"])
    PID = until(lambda: adb("shell", "pidof", PACKAGE), 20)
    check("one application PID", PID.isdigit(), PID)
    until(lambda: "SLICE_READY" in logs() and "SLICE_FIRST_FRAME" in logs(), 25)
    (OUT / f"launch-{PID}.log").write_text(result, encoding="utf-8")
    frame = re.search(r"SLICE_FIRST_FRAME since_ready_ms=([0-9.]+)", logs())
    REPORT.setdefault("processes", []).append({"pid": PID, "launch": result,
                                              "first_frame_since_ready_ms": float(frame.group(1)) if frame else None})
    return result


def pause() -> None:
    cursor = len(logs())
    tap("buttons", "pause")
    wait_event("SLICE_PAUSE", cursor)


def options(reduced: bool, sound: bool) -> None:
    for key, desired in [("reduce_motion", reduced), ("sound", sound)]:
        if saved()["preferences"][key] != desired:
            tap("buttons", key)
            until(lambda: saved()["preferences"][key] == desired)


def solve(level: dict) -> None:
    for move in level["solution_commands"]:
        for _ in range(move["quarter_turns"]):
            tap("cells", move["index"])


def verify(apk: Path) -> None:
    check("dedicated AVD identity", adb("emu", "avd", "name").splitlines()[0] == AVD)
    badging = native([str(SDK / "build-tools/36.1.0/aapt.exe"), "dump", "badging", str(apk)]).decode("utf-8", errors="replace")
    package_match = re.search(r"package: name='([^']+)'", badging)
    check("APK belongs to studio slice", package_match is not None and package_match.group(1) == PACKAGE)
    REPORT.update(apk_sha256=hashlib.file_digest(apk.open("rb"), "sha256").hexdigest(), apk_bytes=apk.stat().st_size,
                  android_api=adb("shell", "getprop", "ro.build.version.sdk"), android_release=adb("shell", "getprop", "ro.build.version.release"),
                  display=adb("shell", "wm", "size"), density=adb("shell", "wm", "density"), gpu_backend="host (configured AVD)")
    (OUT / "apk-badging.log").write_text(badging, encoding="utf-8")
    check("APK install succeeds", "Success" in adb("install", "-r", str(apk)))
    resolved = adb("shell", "cmd", "package", "resolve-activity", "--brief", PACKAGE).splitlines()[-1]
    check("launcher resolves to this package", re.fullmatch(re.escape(PACKAGE) + r"/[A-Za-z0-9_.$]+", resolved) is not None, resolved)
    REPORT["activity"] = resolved
    adb("shell", "am", "force-stop", PACKAGE)
    launch()
    pause()
    options(False, False)
    tap("buttons", "restart")
    until(lambda: saved()["rotations"] == saved()["attempts"] == saved()["hints"] == 0)
    initial = snapshot("initial")
    capture("planning")
    tap("cells", 8)
    until(lambda: saved()["rotations"] == 1)
    check("one real tap makes one rotation", saved()["rotations"] == 1)
    tap("buttons", "undo")
    until(lambda: saved()["rotations"] == 0)
    check("undo restores initial rails", saved()["ports"] == initial["ports"])
    tap("cells", 6)
    check("fixed source is not rotated", saved()["ports"] == initial["ports"] and saved()["rotations"] == 0)
    tap("buttons", "hint")
    until(lambda: saved()["hints"] == 1)
    check("hint does not move rails", saved()["ports"] == initial["ports"])
    cursor = len(logs())
    tap("buttons", "dispatch")
    wait_event("SLICE_RESULT success=false", cursor)
    check("failed attempt counted", snapshot("failed")["attempts"] == 1)
    capture("failed")
    level = json.loads((GAME / "data/archipel_double_flux.json").read_text(encoding="utf-8"))
    solve(level)
    prepared = snapshot("prepared")
    solved_ports = [sum({"N": 1, "E": 2, "S": 4, "W": 8}[d] for d in code) for row in level["solved_grid"] for code in row]
    check("authored preparation reached", prepared["rotations"] == level["reference_rotations"] and prepared["ports"] == solved_ports)
    capture("prepared")
    record, record_log = None, None
    video_available = subprocess.run(ADB + ["shell", "which", "screenrecord"], env=ENV, capture_output=True, timeout=10).returncode == 0
    if video_available:
        remote_video = "/sdcard/switchworks_slice_" + REPORT["stamp"] + ".mp4"
        record_log = (OUT / "screenrecord.log").open("wb")
        record = subprocess.Popen(ADB + ["shell", "screenrecord", "--time-limit", "8", "--size", "720x1600", "--bit-rate", "6000000", remote_video], env=ENV, stdout=record_log, stderr=subprocess.STDOUT)
    cursor = len(logs())
    tap("buttons", "dispatch")
    time.sleep(0.35)
    capture("in-motion")
    wait_event("SLICE_RESULT success=true", cursor)
    won = snapshot("won")
    check("six rotations and two attempts preserved at victory", won["rotations"] == 6 and won["attempts"] == 2)
    capture("won")
    if record:
        record.wait(timeout=12)
        record_log.close()
        if record.returncode == 0:
            adb("pull", remote_video, str(OUT / "android-gameplay.mp4"))
        video = OUT / "android-gameplay.mp4"
        actual_size = None
        if video.exists():
            encoded = video.read_bytes()
            marker = encoded.find(b"tkhd")
            if marker >= 4:
                atom_size = int.from_bytes(encoded[marker - 4:marker], "big")
                track = encoded[marker - 4:marker - 4 + atom_size]
                actual_size = [int.from_bytes(track[-8:-4], "big") >> 16, int.from_bytes(track[-4:], "big") >> 16]
        REPORT["video"] = {"requested_seconds": 8, "requested_size": [720, 1600], "actual_track_size": actual_size,
                           "exit_code": record.returncode, "saved": video.exists(), "audio_recorded": False}
    else:
        REPORT["video"] = {"saved": False, "reason": "screenrecord unavailable"}
    old_pid, cursor = PID, len(logs())
    adb("shell", "input", "keyevent", "KEYCODE_HOME")
    time.sleep(0.4)
    resume = adb("shell", "am", "start", "-W", "-n", resolved)
    current_pid = adb("shell", "pidof", PACKAGE)
    launch_state = re.search(r"LaunchState:\s*(.+)", resume)
    REPORT["home_resume"] = {"before_pid": old_pid, "after_pid": current_pid, "am_output": resume,
                             "observed_launch_state": launch_state.group(1) if launch_state else None}
    check("Home returns to same application process", current_pid == old_pid and "Status: ok" in resume, REPORT["home_resume"])
    wait_event("SLICE_PAUSE", cursor)
    capture("home-resumed-paused")
    cursor = len(logs())
    tap("buttons", "resume")
    wait_event("SLICE_RESUME", cursor)
    check("Home retains counters and rails", saved() == won)
    tap("buttons", "victory_replay")
    until(lambda: saved()["rotations"] == saved()["attempts"] == 0)
    solve(level)
    cursor = len(logs())
    tap("buttons", "dispatch", 0.1)
    time.sleep(0.35)
    capture("running-before-home")
    adb("shell", "input", "keyevent", "KEYCODE_HOME")
    time.sleep(0.4)
    adb("shell", "am", "start", "-W", "-n", resolved)
    wait_event("SLICE_PAUSE phase=running", cursor)
    capture("running-resumed-paused")
    tap("buttons", "resume")
    wait_event("SLICE_RESUME phase=running", cursor)
    wait_event("SLICE_RESULT success=true", cursor)
    check("mid-run resume does not redispatch", saved()["attempts"] == 1 and adb("shell", "pidof", PACKAGE) == old_pid)
    capture("won-after-running-resume")
    durable = snapshot("before-force-stop")
    (OUT / f"app-{PID}.log").write_text(logs(), encoding="utf-8")
    adb("shell", "am", "force-stop", PACKAGE)
    launch()
    check("new process restores saved preparation", PID != old_pid and saved() == durable)
    check("restoration was observed by the game", "SLICE_LOCAL_STATE_RESTORED" in logs())
    capture("restored-preparation")
    pause()
    options(True, True)
    tap("buttons", "resume")
    tap("cells", 8)
    tap("buttons", "undo")
    check("options and reduced-motion input work", saved()["ports"] == durable["ports"] and all(saved()["preferences"].values()))
    REPORT["audio_listened"] = False
    time.sleep(11)
    metrics = [json.loads(line.split("SLICE_METRICS ", 1)[1]) for line in logs().splitlines() if "SLICE_METRICS " in line]
    check("idle metrics observed", bool(metrics))
    REPORT["idle_observation_seconds"], REPORT["metrics"] = 11, metrics[-1]
    memory = adb("shell", "dumpsys", "meminfo", PACKAGE)
    (OUT / "memory.log").write_text(memory, encoding="utf-8")
    pss = re.search(r"TOTAL PSS:\s*(\d+)", memory)
    REPORT["total_pss_kib"] = int(pss.group(1)) if pss else None
    check("application PSS was measured", REPORT["total_pss_kib"] is not None and REPORT["total_pss_kib"] > 0)
    pause()
    options(False, False)
    tap("buttons", "restart")
    until(lambda: saved()["rotations"] == saved()["attempts"] == saved()["hints"] == 0)
    capture("handoff-planning")
    snapshot("handoff")
    check("APK bytes unchanged during recipe", hashlib.file_digest(apk.open("rb"), "sha256").hexdigest() == REPORT["apk_sha256"])


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--apk", type=Path, default=GAME / "build/android/switchworks-archipel-slice-debug.apk")
    args = parser.parse_args()
    REPORT["stamp"] = datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ")
    OUT = GAME / "artifacts/slice-android" / ("final-" + REPORT["stamp"])
    OUT.mkdir(parents=True, exist_ok=False)
    print("Artifacts:", OUT, flush=True)
    try:
        verify(args.apk.resolve())
        REPORT["status"] = "passed"
    except Exception as error:
        REPORT.update(status="failed", error=f"{type(error).__name__}: {error}")
        print(REPORT["error"], flush=True)
        if PID:
            try:
                capture("failure-state")
            except Exception as capture_error:
                REPORT["failure_capture_error"] = str(capture_error)
    finally:
        try:
            text = logs()
        except Exception as log_error:
            text = ""
            REPORT["log_collection_error"] = str(log_error)
        (OUT / f"app-{PID or 'unavailable'}.log").write_text(text, encoding="utf-8")
        all_logs = "\n".join(path.read_text(encoding="utf-8") for path in OUT.glob("app-*.log"))
        REPORT["godot_error_lines"] = [line for line in all_logs.splitlines() if re.search(r"SCRIPT ERROR|ERROR:|FATAL EXCEPTION", line)]
        REPORT["native_error_lines"] = [line for line in all_logs.splitlines() if re.search(r"\sE\s", line)]
        REPORT["renderer_log"] = [line for line in all_logs.splitlines() if "OpenGL API" in line or "Using Device:" in line]
        if REPORT["godot_error_lines"]:
            REPORT["status"] = "failed"
        (OUT / "receipt.json").write_text(json.dumps(REPORT, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print("Receipt:", OUT / "receipt.json", flush=True)
    raise SystemExit(0 if REPORT["status"] == "passed" else 1)
