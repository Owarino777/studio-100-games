extends ArchipelScreen
## Composition study; inherited domain, interactions and state machine stay intact.

const STUDY_SAVE = "user://littoral_composition_v1.json"
var _board_card: Panel
var _study_last_us: int = 0
var _study_intervals: Array[float] = []
var _study_draws: Array[float] = []
var _evidence_directory: String = ""
var _receipt_frame_saved: bool = false


func _ready() -> void:
	super._ready()
	print("LITTORAL_RENDER_CONTRACT " + JSON.stringify((_view as LittoralBoardView).get_render_contract()))
	for argument: String in OS.get_cmdline_user_args():
		if argument == "--study-video": call_deferred("_video_sequence")
		elif argument.begins_with("--study-frames="):
			_evidence_directory = argument.trim_prefix("--study-frames=")
			DirAccess.make_dir_recursive_absolute(_evidence_directory)


func _build_ui() -> void:
	super._build_ui()
	_board_card = Panel.new()
	_board_card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var card: StyleBoxFlat = PostalTheme.panel(Color("eddec1"), 20)
	card.shadow_size = 8
	card.shadow_color = Color(0.13, 0.25, 0.28, 0.18)
	card.border_color = Color("fff4df")
	card.set_border_width_all(2)
	_board_card.add_theme_stylebox_override("panel", card)
	add_child(_board_card)
	move_child(_board_card, 1)
	move_child(_view, 2)
	_eyebrow.text = "SWITCHWORKS  /  ÉTUDE CÉRAMIQUE LITTORALE"
	_eyebrow.add_theme_color_override("font_color", Color("355b6b"))
	_title.add_theme_font_size_override("font_size", 24)
	_title.add_theme_color_override("font_color", Color("173b54"))
	_subtitle.text = "Livrez A à A et B à B"
	_subtitle.add_theme_font_size_override("font_size", 16)
	_header.add_theme_stylebox_override("panel", StyleBoxEmpty.new())
	_buttons["pause"].text = "II"
	_buttons["pause"].add_theme_font_size_override("font_size", 20)
	for key: String in ["undo", "dispatch", "hint", "pause"]:
		var button: Button = _buttons[key]
		var base: Color = Color("f4b56a") if key == "dispatch" else Color("fff3dc")
		for state: String in ["normal", "hover", "pressed", "disabled"]:
			var color: Color = base.lightened(0.08) if state == "hover" else (base.darkened(0.10) if state == "pressed" else base)
			if state == "disabled": color = Color("d9ddd2")
			var box: StyleBoxFlat = PostalTheme.panel(color, 14)
			box.border_color = Color("fdf6e9")
			box.set_border_width_all(2)
			box.shadow_offset = Vector2(0, 3)
			button.add_theme_stylebox_override(state, box)
		button.add_theme_color_override("font_color", Color("173b54"))
		button.add_theme_font_size_override("font_size", 18 if key == "dispatch" else 15)
	var stats_box: StyleBoxFlat = PostalTheme.panel(Color("fff3dc"), 12)
	stats_box.set_content_margin_all(6)
	_stats_panel.add_theme_stylebox_override("panel", stats_box)
	for node: Node in _stats_panel.find_children("*", "Label", true, false):
		var label := node as Label
		label.add_theme_font_size_override("font_size", 18 if _stats.values().has(label) else 12)
	_status.add_theme_font_size_override("font_size", 14)


func _create_board_view() -> PostalBoardView:
	return LittoralBoardView.new()


func _process(delta: float) -> void:
	var now: int = Time.get_ticks_usec()
	if _phase == "running" and not _paused and _study_last_us > 0:
		_study_intervals.append(float(now - _study_last_us) / 1000.0)
		_study_draws.append(Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME))
	_study_last_us = now
	super._process(delta)
	if not _evidence_directory.is_empty() and not _receipt_frame_saved and _phase == "running":
		var state: Dictionary = _view.get_reception_state("A")
		if (state["lid_rotation"] as Vector3).length() > 0.03:
			_receipt_frame_saved = true
			call_deferred("_save_evidence_frame", "reception")


func dispatch() -> void:
	if _paused or _phase in ["running", "won"] or _busy_time > 0: return
	_study_intervals.clear()
	_study_draws.clear()
	super.dispatch()


func _finish_dispatch() -> void:
	super._finish_dispatch()
	if _study_intervals.is_empty(): return
	var intervals: Array[float] = _study_intervals.duplicate()
	var draws: Array[float] = _study_draws.duplicate()
	intervals.sort()
	draws.sort()
	print("LITTORAL_PERF " + JSON.stringify({"platform": OS.get_name(), "result_phase": _phase,
		"samples": intervals.size(), "process_interval_p50_ms": intervals[intervals.size() / 2],
		"process_interval_p95_ms": intervals[mini(intervals.size() - 1, floori(intervals.size() * 0.95))],
		"draw_calls_p50": draws[draws.size() / 2], "draw_calls_max": draws[-1],
		"static_memory_bytes": Performance.get_monitor(Performance.MEMORY_STATIC),
		"video_fixed_fps": OS.get_cmdline_user_args().has("--study-video"),
		"limits": "process wall intervals, not GPU timing; cache, debugger, emulator, recording and synthetic tests affect values"}))


func _layout() -> void:
	if _view == null or _board_card == null: return
	var safe: Rect2 = _safe_rect()
	if safe.size.x > safe.size.y * 1.2:
		super._layout()
		_board_card.set_deferred("visible", false)
		return
	_board_card.show()
	var x: float = safe.position.x + 16
	var width: float = safe.size.x - 32
	_place(_eyebrow, Rect2(x, safe.position.y + 12, width, 15))
	_place(_header, Rect2(x, safe.position.y + 30, width - 54, 65))
	_place(_title, Rect2(x, safe.position.y + 30, width - 54, 32))
	_place(_subtitle, Rect2(x, safe.position.y + 69, width, 25))
	_place(_buttons["pause"], Rect2(safe.end.x - 64, safe.position.y + 31, 48, 48))
	var board_height: float = minf(safe.size.x * 0.98, safe.size.y - 300)
	var board_top: float = safe.position.y + 108 + maxf(0, safe.size.y - board_height - 330) * 0.30
	_place(_view, Rect2(safe.position.x, board_top, safe.size.x, board_height))
	_place(_stats_panel, Rect2(x + 4, board_top + board_height, width - 8, 54))
	_place(_board_card, Rect2(safe.position.x + 3, board_top + 5, safe.size.x - 6, board_height + 65))
	_place(_status, Rect2(x, board_top + board_height + 76, width, 46))
	_layout_actions(Rect2(x, safe.end.y - 68, width, 52))
	_place(_footer, Rect2(x, safe.end.y - 10, width, 1))
	var victory_width: float = minf(340, safe.size.x - 24)
	_place(_victory, Rect2(safe.get_center().x - victory_width * 0.5, safe.end.y - 202, victory_width, 118))
	_place(_pause_panel, Rect2(safe.get_center() - Vector2(victory_width, 350) * 0.5, Vector2(victory_width, 350)))


func _save_local_state() -> void:
	if _board == null or DisplayServer.get_name() == "headless" or not OS.get_cmdline_user_args().is_empty(): return
	var state: Dictionary = _board.snapshot()
	state["ports"] = Array(state["ports"])
	state["preferences"] = {"reduce_motion": _reduce_motion, "sound": _sound_enabled}
	var file := FileAccess.open(STUDY_SAVE + ".tmp", FileAccess.WRITE)
	if file == null:
		push_warning("LITTORAL_SAVE_UNAVAILABLE")
		return
	file.store_string(JSON.stringify(state))
	file.close()
	var error: Error = DirAccess.rename_absolute(ProjectSettings.globalize_path(STUDY_SAVE + ".tmp"), ProjectSettings.globalize_path(STUDY_SAVE))
	if error != OK: push_warning("LITTORAL_SAVE_RENAME_FAILED")


func _load_local_state() -> void:
	if DisplayServer.get_name() == "headless" or not OS.get_cmdline_user_args().is_empty() or not FileAccess.file_exists(STUDY_SAVE): return
	var decoded: Variant = JSON.parse_string(FileAccess.get_file_as_string(STUDY_SAVE))
	if decoded is Dictionary and restore_preparation(decoded):
		var preferences: Variant = decoded.get("preferences", {})
		if preferences is Dictionary:
			_loading_state = true
			set_reduced_motion(preferences.get("reduce_motion", false) == true)
			_sound_enabled = preferences.get("sound", false) == true
			_sound_toggle.set_pressed_no_signal(_sound_enabled)
			_loading_state = false


func _video_sequence() -> void:
	await get_tree().create_timer(0.6).timeout
	# Real input and existing commands on the same level, no fabricated paths/results.
	_send_window_click(_buttons["dispatch"].get_global_rect().get_center())
	await get_tree().create_timer(3.3).timeout
	restart_level()
	for command: Dictionary in _board.level.solution_commands:
		for turn in int(command["quarter_turns"]):
			_send_window_click(_view.index_to_canvas_center(int(command["index"])))
			await get_tree().create_timer(0.27).timeout
	dispatch()
	await get_tree().create_timer(3.4).timeout
	if not _evidence_directory.is_empty(): await _save_evidence_frame("won")
	_log_metrics()
	get_tree().quit(0 if _phase == "won" else 1)


func _send_window_click(logical_point: Vector2) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	# parse_input_event uses window pixels; the root canvas then applies stretch.
	event.position = logical_point * Vector2(get_window().size) / get_viewport_rect().size
	Input.parse_input_event(event)
	var up := event.duplicate() as InputEventMouseButton
	up.pressed = false
	Input.parse_input_event(up)


func _save_evidence_frame(id: String) -> void:
	await RenderingServer.frame_post_draw
	var error: Error = get_viewport().get_texture().get_image().save_png(_evidence_directory.path_join(id + ".png"))
	if error != OK: push_error("LITTORAL_EVIDENCE_WRITE_FAILED")
