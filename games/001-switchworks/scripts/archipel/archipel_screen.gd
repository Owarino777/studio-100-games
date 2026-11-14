class_name ArchipelScreen
extends Control
## Experimental single-level scene. Bootstrap and puzzle model remain separate.

const SKY: Texture2D = preload("res://assets/archipel/textures/sky-paper-v1.png")
const FONT_INK := Color("203c56")
const SAVE_PATH: String = "user://archipel_slice_v1.json"

var _board: PostalBoard
var _view: PostalBoardView
var _phase: String = "planning"
var _paused: bool = false
var _reduce_motion: bool = false
var _sound_enabled: bool = false
var _busy_time: float = 0.0
var _elapsed: float = 0.0
var _last_result: Dictionary = {}
var _deliveries: int = 0
var _old_fps: int = 0
var _stats: Dictionary[String, Label] = {}
var _buttons: Dictionary[String, Button] = {}
var _eyebrow: Label
var _header: PanelContainer
var _title: Label
var _subtitle: Label
var _stats_panel: PanelContainer
var _status: Label
var _footer: Label
var _pause_cover: ColorRect
var _pause_panel: PanelContainer
var _pause_note: Label
var _reduce_toggle: CheckButton
var _sound_toggle: CheckButton
var _victory: PanelContainer
var _victory_text: Label
var _metrics: PackedFloat32Array = PackedFloat32Array()
var _frame: int = 0
var _shot_path: String = ""
var _shot_scenario: String = "planning"
var _shot_done: bool = false
var _capture_frames: int = 0
var _previous_frame_us: int = 0
var _ready_started_us: int = 0
var _loading_state: bool = false
var _original_scale_size: Vector2i
var _restored_preparation: bool = false
var _guidance_state: String = "fresh"
var _layout_log_queued: bool = false
var _web_window: JavaScriptObject
var _web_document: JavaScriptObject
var _web_safe_area_probe: JavaScriptObject
var _web_visibility_callback: JavaScriptObject
var _web_hide_callback: JavaScriptObject
var _web_show_callback: JavaScriptObject
var _web_storage_available: bool = true


func _ready() -> void:
	_ready_started_us = Time.get_ticks_usec()
	_old_fps = Engine.max_fps
	Engine.max_fps = 60
	_original_scale_size = get_window().content_scale_size
	_setup_web_environment()
	_adapt_window_scale()
	get_window().size_changed.connect(_adapt_window_scale)
	theme = PostalTheme.make_theme()
	PostalArtFactory.configure_font(PostalTheme.font(800))
	var level: PostalLevel = PostalLevel.load_default()
	if level == null:
		var error := Label.new()
		error.text = "Le niveau n'a pas pu être chargé. Relancez cette version de test."
		error.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		add_child(error)
		push_error("SLICE_LEVEL_LOAD_FAILED")
		return
	_board = PostalBoard.new(level)
	_build_ui()
	_view.configure(level, _board.ports)
	# Size the text controls before loading a saved preparation. A wrapping Label
	# with an initial width of zero can otherwise grow to a screen-sized minimum.
	_layout()
	_load_local_state()
	_refresh_controls()
	resized.connect(_layout)
	_layout()
	_buttons["dispatch"].grab_focus()
	if not _restored_preparation:
		_set_planning_guidance()
	for argument: String in OS.get_cmdline_user_args():
		if argument.begins_with("--slice-shot="):
			_shot_path = argument.trim_prefix("--slice-shot=")
		elif argument.begins_with("--slice-scenario="):
			_shot_scenario = argument.trim_prefix("--slice-scenario=")
	if not _shot_path.is_empty():
		call_deferred("_prepare_capture_scenario")
	print("SLICE_READY engine=%s platform=%s level=%s" % [Engine.get_version_info()["string"], OS.get_name(), level.id])
	_queue_layout_log()
	call_deferred("_first_frame_marker")
	if OS.has_feature("web"):
		_report_web_state("ready")
		_warn_web_storage()
		if _web_document != null and bool(_web_document.hidden):
			_suspend_web("initially_hidden")


func _build_ui() -> void:
	var sky := TextureRect.new()
	sky.texture = SKY
	sky.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	sky.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	sky.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(sky)
	sky.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_eyebrow = _label("SWITCHWORKS  ·  LES DEUX TOURNÉES", 9, 700)
	_eyebrow.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_header = PanelContainer.new()
	_header.add_theme_stylebox_override("panel", PostalTheme.panel())
	add_child(_header)
	_title = _label("ARCHIPEL POSTAL", 18, 850)
	# Web exports cannot rely on native-system fallback glyphs for these symbols.
	_subtitle = _label("Livrez A à A et B à B" if OS.has_feature("web") else "Livrez A → A et B → B", 15, 750)
	_buttons["pause"] = _button("II" if OS.has_feature("web") else "Ⅱ", pause_game, "Pause")
	_buttons["pause"].tooltip_text = "Mettre en pause et ouvrir les options"
	_stats_panel = PanelContainer.new()
	var stats_box: StyleBoxFlat = PostalTheme.panel(PostalTheme.CREAM, 14)
	stats_box.set_content_margin_all(4)
	_stats_panel.add_theme_stylebox_override("panel", stats_box)
	add_child(_stats_panel)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	_stats_panel.add_child(row)
	for key: String in ["deliveries", "rotations", "attempts"]:
		var column := VBoxContainer.new()
		column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		column.add_theme_constant_override("separation", 0)
		row.add_child(column)
		var caption := Label.new()
		caption.text = {"deliveries": "LIVRAISONS", "rotations": "ROTATIONS", "attempts": "ESSAIS"}[key]
		caption.add_theme_font_size_override("font_size", 9)
		caption.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		column.add_child(caption)
		var value := Label.new()
		value.add_theme_font_override("font", PostalTheme.font(850))
		value.add_theme_font_size_override("font_size", 16)
		value.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		column.add_child(value)
		_stats[key] = value
	_view = PostalBoardView.new()
	add_child(_view)
	_view.cell_pressed.connect(rotate_cell)
	_status = _label("", 14, 650)
	_status.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_status.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	# Context copy has at most two explicit, bounded lines. Its geometry must not
	# depend on font shaping before the first Android layout has established width.
	_status.autowrap_mode = TextServer.AUTOWRAP_OFF
	_buttons["undo"] = _button("Annuler", undo_move, "Undo")
	_buttons["dispatch"] = _button("Expédier", dispatch, "Dispatch")
	_buttons["dispatch"].add_theme_font_override("font", PostalTheme.font(900))
	_buttons["dispatch"].add_theme_font_size_override("font_size", 20)
	_buttons["dispatch"].add_theme_stylebox_override("normal", PostalTheme.button_box(Color("edaa7d")))
	_buttons["dispatch"].add_theme_stylebox_override("hover", PostalTheme.button_box(Color("f5bd91")))
	_buttons["dispatch"].add_theme_stylebox_override("pressed", PostalTheme.button_box(Color("de9771")))
	_buttons["hint"] = _button("Indice", request_hint, "Hint")
	# One contextual instruction above the board replaces the old repeated footer.
	_footer = _label("", 12, 650)
	_footer.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_footer.hide()
	_build_pause()
	_build_victory()


func _build_pause() -> void:
	_pause_cover = ColorRect.new()
	_pause_cover.color = Color(0.10, 0.21, 0.28, 0.48)
	_pause_cover.z_index = 10
	_pause_cover.visible = false
	add_child(_pause_cover)
	_pause_cover.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_pause_panel = PanelContainer.new()
	_pause_panel.z_index = 11
	_pause_panel.add_theme_stylebox_override("panel", PostalTheme.panel())
	_pause_panel.visible = false
	add_child(_pause_panel)
	var contents := VBoxContainer.new()
	contents.add_theme_constant_override("separation", 8)
	_pause_panel.add_child(contents)
	var heading := Label.new()
	heading.text = "Le courrier peut attendre"
	heading.add_theme_font_size_override("font_size", 22)
	heading.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	contents.add_child(heading)
	_pause_note = Label.new()
	_pause_note.text = "Votre préparation est conservée."
	_pause_note.add_theme_font_size_override("font_size", 14)
	_pause_note.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	contents.add_child(_pause_note)
	_buttons["resume"] = _button_in(contents, "Reprendre", resume_game, "Resume")
	_buttons["restart"] = _button_in(contents, "Recommencer le niveau", restart_level, "Restart")
	_reduce_toggle = CheckButton.new()
	_reduce_toggle.name = "ReduceMotion"
	_reduce_toggle.text = "Mouvement réduit"
	_reduce_toggle.custom_minimum_size.y = 48
	_reduce_toggle.toggled.connect(set_reduced_motion)
	contents.add_child(_reduce_toggle)
	_sound_toggle = CheckButton.new()
	_sound_toggle.text = "Sons discrets"
	_sound_toggle.custom_minimum_size.y = 48
	_sound_toggle.toggled.connect(_set_sound_enabled)
	contents.add_child(_sound_toggle)
	var focus_cycle: Array[Control] = [_buttons["resume"], _buttons["restart"], _reduce_toggle, _sound_toggle]
	for index: int in range(focus_cycle.size()):
		var control: Control = focus_cycle[index]
		control.focus_next = focus_cycle[(index + 1) % focus_cycle.size()].get_path()
		control.focus_previous = focus_cycle[(index + focus_cycle.size() - 1) % focus_cycle.size()].get_path()


func _build_victory() -> void:
	_victory = PanelContainer.new()
	_victory.z_index = 6
	_victory.visible = false
	var victory_box: StyleBoxFlat = PostalTheme.panel(Color("f5f2df"))
	victory_box.set_content_margin_all(8)
	_victory.add_theme_stylebox_override("panel", victory_box)
	add_child(_victory)
	var contents := VBoxContainer.new()
	contents.add_theme_constant_override("separation", 6)
	_victory.add_child(contents)
	_victory_text = Label.new()
	_victory_text.text = "Deux colis livrés !"
	_victory_text.add_theme_font_override("font", PostalTheme.font(850))
	_victory_text.add_theme_font_size_override("font_size", 18)
	_victory_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	# Both lines are authored and bounded by _format_counter. Automatic wrapping
	# while the panel is hidden can inflate its minimum height before layout.
	_victory_text.autowrap_mode = TextServer.AUTOWRAP_OFF
	contents.add_child(_victory_text)
	_buttons["victory_replay"] = _button_in(contents, "Rejouer cette tournée", restart_level, "Replay")


func _label(text: String, font_size: int, weight: float) -> Label:
	var label := Label.new()
	label.text = text
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_font_override("font", PostalTheme.font(weight))
	add_child(label)
	return label


func _button(text: String, action: Callable, node_name: String) -> Button:
	var button := Button.new()
	button.name = node_name
	button.text = text
	button.focus_mode = Control.FOCUS_ALL
	button.pressed.connect(action)
	add_child(button)
	return button


func _button_in(parent: Control, text: String, action: Callable, node_name: String) -> Button:
	var button := _button(text, action, node_name)
	button.reparent(parent)
	button.custom_minimum_size.y = 48
	return button


func _layout() -> void:
	if _view == null:
		return
	var safe: Rect2 = _safe_rect()
	var wide: bool = safe.size.x > safe.size.y * 1.2
	var margin: float = 16.0
	if wide:
		var side: float = minf(safe.size.y - 16, safe.size.x * 0.47)
		_place(_view, Rect2(safe.position.x, safe.position.y + 8, side, side))
		var x: float = safe.position.x + side + 12
		var width: float = safe.end.x - x - margin
		_place(_eyebrow, Rect2(x, safe.position.y + 10, width, 14))
		_place(_header, Rect2(x, safe.position.y + 28, width, 64))
		_place(_title, Rect2(x + 12, safe.position.y + 33, width - 74, 26))
		_place(_subtitle, Rect2(x + 12, safe.position.y + 62, width - 74, 24))
		_place(_buttons["pause"], Rect2(x + width - 60, safe.position.y + 36, 48, 48))
		_place(_stats_panel, Rect2(x, safe.position.y + 100, width, 44))
		_place(_status, Rect2(x, safe.position.y + 156, width, 54))
		_layout_actions(Rect2(x, safe.end.y - 64, width, 48))
		_place(_footer, Rect2(x, safe.end.y - 16, width, 1))
		_place(_victory, Rect2(x, safe.end.y - 134, width, 118))
	else:
		var width: float = safe.size.x - margin * 2
		var x: float = safe.position.x + margin
		_place(_eyebrow, Rect2(x, safe.position.y + 10, width, 14))
		_place(_header, Rect2(x, safe.position.y + 28, width, 64))
		_place(_title, Rect2(x + 12, safe.position.y + 33, width - 74, 26))
		_place(_subtitle, Rect2(x + 12, safe.position.y + 62, width - 74, 24))
		_place(_buttons["pause"], Rect2(x + width - 60, safe.position.y + 36, 48, 48))
		_place(_stats_panel, Rect2(x, safe.position.y + 100, width, 44))
		var board_start: float = 198
		var board_space: float = maxf(150, safe.size.y - board_start - 80)
		var side: float = minf(safe.size.x, board_space)
		var board_top: float = safe.position.y + board_start + maxf(0, (board_space - side) * 0.3)
		_place(_view, Rect2(safe.position.x + (safe.size.x - side) * 0.5, board_top, side, side))
		_place(_status, Rect2(x, board_top - 48, width, 44))
		_layout_actions(Rect2(x, safe.end.y - 64, width, 48))
		_place(_footer, Rect2(x, safe.end.y - 16, width, 1))
		var victory_width: float = minf(340, safe.size.x - 24)
		_place(_victory, Rect2(Vector2(safe.get_center().x - victory_width * 0.5, safe.end.y - 134), Vector2(victory_width, 118)))
	var panel_width: float = minf(340, safe.size.x - 24)
	_place(_pause_panel, Rect2(safe.get_center() - Vector2(panel_width, 350) * 0.5, Vector2(panel_width, 350)))


func _layout_actions(rect: Rect2) -> void:
	var side_width: float = minf(76, rect.size.x * 0.23)
	_place(_buttons["undo"], Rect2(rect.position, Vector2(side_width, rect.size.y)))
	_place(_buttons["hint"], Rect2(Vector2(rect.end.x - side_width, rect.position.y), Vector2(side_width, rect.size.y)))
	_place(_buttons["dispatch"], Rect2(Vector2(rect.position.x + side_width + 8, rect.position.y), Vector2(rect.size.x - side_width * 2 - 16, rect.size.y)))


static func _place(control: Control, rect: Rect2) -> void:
	control.position = rect.position
	control.size = rect.size


func _safe_rect() -> Rect2:
	var full := Rect2(Vector2.ZERO, get_viewport_rect().size)
	if OS.has_feature("web") and _web_window != null and _web_safe_area_probe != null:
		var css_size := Vector2(float(_web_window.innerWidth), float(_web_window.innerHeight))
		if css_size.x > 0.0 and css_size.y > 0.0:
			var style: JavaScriptObject = _web_window.getComputedStyle(_web_safe_area_probe)
			var left: float = maxf(0.0, float(str(style.paddingLeft).trim_suffix("px")))
			var top: float = maxf(0.0, float(str(style.paddingTop).trim_suffix("px")))
			var right: float = maxf(0.0, float(str(style.paddingRight).trim_suffix("px")))
			var bottom: float = maxf(0.0, float(str(style.paddingBottom).trim_suffix("px")))
			var ratio: Vector2 = full.size / css_size
			var inset := Rect2(Vector2(left, top) * ratio, full.size - Vector2(left + right, top + bottom) * ratio)
			return inset if inset.has_area() else full
	if not (OS.has_feature("android") or OS.has_feature("ios")):
		return full
	var window := Rect2(Vector2(DisplayServer.window_get_position()), Vector2(DisplayServer.window_get_size()))
	var reported := Rect2(DisplayServer.get_display_safe_area()).intersection(window)
	if not reported.has_area() or not window.has_area():
		return full
	return Rect2((reported.position - window.position) / window.size * full.size, reported.size / window.size * full.size)


func rotate_cell(index: int) -> bool:
	if _paused or _phase in ["running", "won"] or _busy_time > 0:
		return false
	if not _board.rotate(index):
		_set_guidance("Ce quai est fixe.\nChoisissez une voie à tourner." if _board.level.fixed_indices.has(index) else "Choisissez une voie à tourner.", _guidance_state)
		return false
	_restored_preparation = false
	_phase = "planning"
	_deliveries = 0
	_victory.hide()
	_view.reset_parcels()
	_view.show_invalid(-1)
	_view.set_selected(index)
	_view.sync_ports(_board.ports, -1 if _reduce_motion else index)
	_busy_time = 0.0 if _reduce_motion else 0.17
	_set_planning_guidance()
	_refresh_controls()
	_save_local_state()
	_play_tone(520, 0.035)
	print("SLICE_ROTATE index=%d rotations=%d" % [index, _board.rotations])
	return true


func dispatch() -> void:
	if _paused or _phase in ["running", "won"] or _busy_time > 0:
		return
	_last_result = _board.simulate()
	_phase = "running"
	_elapsed = 0
	_deliveries = 0
	_view.show_invalid(-1)
	_view.prepare_simulation(_last_result)
	_set_guidance("Livraison en cours.\nLes colis rejoignent leurs boîtes.", "running")
	_refresh_controls()
	_save_local_state()
	print("SLICE_DISPATCH attempt=%d expected=%s" % [_board.attempts, _last_result["reason"]])


func _process(delta: float) -> void:
	if _board == null:
		return
	_frame += 1
	var now_us: int = Time.get_ticks_usec()
	if _frame > 60 and _previous_frame_us > 0:
		_metrics.append(float(now_us - _previous_frame_us) / 1000.0)
	_previous_frame_us = now_us
	if _frame % 300 == 0:
		_log_metrics()
	if not _paused:
		_busy_time = maxf(0, _busy_time - delta)
		if _phase == "running":
			_elapsed += delta
			var progress: Dictionary = _view.advance_simulation(_elapsed, _reduce_motion)
			_deliveries = int(progress["deliveries"])
			_stats["deliveries"].text = "%d / 2" % _deliveries
			if bool(progress["finished"]):
				_finish_dispatch()
	_capture_frames += 1
	if not _shot_path.is_empty() and not _shot_done and _capture_frames >= 45:
		var desired: bool = (_shot_scenario == "won" and _phase == "won") or (_shot_scenario == "failed" and _phase == "failed") or (_shot_scenario == "paused" and _paused) or _shot_scenario in ["planning", "hint"]
		if desired:
			_shot_done = true
			_capture_frame()


func _finish_dispatch() -> void:
	_view.end_simulation()
	if bool(_last_result["success"]):
		_phase = "won"
		var rotation_summary: String = "%s rotation%s" % [_format_counter(_board.rotations), "" if _board.rotations == 1 else "s"]
		var attempt_summary: String = "%s essai%s" % [_format_counter(_board.attempts), "" if _board.attempts == 1 else "s"]
		_victory_text.text = "Deux colis livrés !\n%s · %s" % [rotation_summary, attempt_summary]
		_set_guidance("Les deux colis sont reçus\naux bonnes adresses.", "won")
		_victory.show()
		_buttons["victory_replay"].grab_focus()
		_play_tone(780, 0.12)
	else:
		_phase = "failed"
		var reason: String = str(_last_result["reason"])
		var messages: Dictionary = {
			"missing_connection": "Une voie n'est pas raccordée.\nTournez le rail encadré.",
			"outside_board": "Cette voie sort du plateau.\nCorrigez le raccord.",
			"wrong_destination": "Ce n'est pas la bonne adresse.\nA rejoint A, B rejoint B.",
			"loop": "Le colis tourne en boucle.\nReliez sa boîte de réception.",
			"unexpected_source": "Cette route mène à un départ,\npas à une boîte de réception.",
		}
		_set_guidance(str(messages.get(reason, "La tournée ne peut pas aboutir.\nVérifiez les raccords.")), "failed")
		_view.show_invalid(_actionable_error_cell())
		_play_tone(280, 0.06)
	_refresh_controls()
	print("SLICE_RESULT success=%s reason=%s deliveries=%d" % [_last_result["success"], _last_result["reason"], _deliveries])


func _actionable_error_cell() -> int:
	var failed: int = int(_last_result["failing_cell"])
	if _board.can_rotate(failed):
		return failed
	for label: String in ["A", "B"]:
		var trace: Dictionary = _last_result["traces"][label]
		if not bool(trace["success"]) and int(trace["failing_cell"]) == failed:
			var path: PackedInt32Array = trace["path"]
			if _board.can_rotate(path[-1]):
				return path[-1]
	return failed


func undo_move() -> bool:
	if _paused or _phase in ["running", "won"] or _busy_time > 0 or not _board.undo():
		return false
	_phase = "planning"
	_restored_preparation = false
	_deliveries = 0
	_victory.hide()
	_view.reset_parcels()
	_view.show_invalid(-1)
	_view.sync_ports(_board.ports)
	_set_planning_guidance()
	_refresh_controls()
	_save_local_state()
	return true


func restart_level() -> void:
	_board.reset()
	_phase = "planning"
	_restored_preparation = false
	_paused = false
	_busy_time = 0
	_deliveries = 0
	_view.set_animation_paused(false)
	_view.reset_parcels()
	_view.show_invalid(-1)
	_view.sync_ports(_board.ports)
	_pause_cover.hide()
	_pause_panel.hide()
	_victory.hide()
	_set_planning_guidance()
	_refresh_controls()
	_save_local_state()
	_buttons["dispatch"].grab_focus()
	print("SLICE_RESET")


func request_hint() -> int:
	if _paused or _phase in ["running", "won"] or _busy_time > 0:
		return -1
	var index: int = _board.hint()
	if index >= 0:
		_view.set_selected(index)
		_set_guidance("Tournez le rail encadré de 90°\npour raccorder la voie.", "hint")
	else:
		_set_planning_guidance()
	_refresh_controls()
	_save_local_state()
	return index


func pause_game() -> void:
	if _paused: return
	_paused = true
	_pause_note.text = "Livraison en pause." if _phase == "running" else ("Deux livraisons conservées." if _phase == "won" else "Votre préparation est conservée.")
	_view.set_animation_paused(true)
	_pause_cover.show()
	_pause_panel.show()
	_refresh_controls()
	_buttons["resume"].grab_focus()
	_save_local_state()
	print("SLICE_PAUSE phase=%s" % _phase)
	_log_guidance()
	_queue_layout_log()


func resume_game() -> void:
	_paused = false
	_view.set_animation_paused(false)
	_pause_cover.hide()
	_pause_panel.hide()
	_refresh_controls()
	if _phase == "running":
		_buttons["pause"].grab_focus()
	elif _phase == "won":
		_buttons["victory_replay"].grab_focus()
	else:
		_buttons["dispatch"].grab_focus()
	print("SLICE_RESUME phase=%s" % _phase)
	_log_guidance()
	_queue_layout_log()


func set_reduced_motion(enabled: bool) -> void:
	_reduce_motion = enabled
	if _reduce_toggle != null:
		_reduce_toggle.set_pressed_no_signal(enabled)
	if enabled and _view != null:
		_view.finish_transitions()
		_busy_time = 0
	if _board != null: _save_local_state()


func _set_sound_enabled(enabled: bool) -> void:
	_sound_enabled = enabled
	_save_local_state()


func _refresh_controls() -> void:
	_stats["rotations"].text = _format_counter(_board.rotations)
	_stats["attempts"].text = _format_counter(_board.attempts)
	_stats["deliveries"].text = "%d / 2" % _deliveries
	for key: String in ["undo", "dispatch", "hint"]:
		_buttons[key].visible = _phase != "won"
	var locked: bool = _paused or _phase in ["running", "won"]
	_buttons["undo"].disabled = locked or not _board.can_undo()
	_buttons["dispatch"].disabled = locked
	_buttons["hint"].disabled = locked
	_buttons["pause"].disabled = _paused
	_buttons["pause"].focus_mode = Control.FOCUS_NONE if _paused else Control.FOCUS_ALL
	_buttons["victory_replay"].focus_mode = Control.FOCUS_NONE if _paused else Control.FOCUS_ALL
	_view.mouse_filter = Control.MOUSE_FILTER_IGNORE if locked else Control.MOUSE_FILTER_STOP
	_view.focus_mode = Control.FOCUS_NONE if locked else Control.FOCUS_ALL
	_status.visible = not _paused and _phase != "won"
	_footer.text = ""
	_footer.hide()


func _set_guidance(text: String, state: String) -> void:
	_status.text = text
	_guidance_state = state
	_status.visible = not _paused and _phase != "won"
	_log_guidance()


func _set_planning_guidance(restored: bool = false) -> void:
	var ready: bool = bool(_board.evaluate().get("success", false))
	if restored:
		_set_guidance("Préparation retrouvée : voies prêtes.\nVous pouvez expédier." if ready else "Préparation retrouvée.\nVérifiez les voies avant d'expédier.", "restored_ready" if ready else "restored_editable")
	elif ready:
		_set_guidance("Les deux voies sont prêtes.\nVous pouvez expédier.", "planning_ready")
	else:
		var fresh: bool = _board.rotations == 0 and _board.attempts == 0 and _board.hints == 0
		_set_guidance("Touchez une voie pour la tourner,\npuis expédiez." if fresh else "Vérifiez les raccords,\npuis expédiez les deux colis.", "fresh" if fresh else "planning_editable")


func _log_guidance() -> void:
	print("SLICE_GUIDANCE %s" % JSON.stringify({"phase": get_phase(), "state": get_guidance_state(), "text": get_guidance_text()}))
	_queue_layout_log()


func _queue_layout_log() -> void:
	# Action diagnostics run after text shaping and control updates, never per frame.
	if _layout_log_queued:
		return
	_layout_log_queued = true
	call_deferred("_log_layout")


static func _format_counter(value: int) -> String:
	return "999+" if value > 999 else str(value)


func _adapt_window_scale() -> void:
	# Keep the inherited portrait policy. A short desktop landscape window needs
	# a 1:1 minimum UI scale rather than shrinking all controls below touch size.
	if not get_viewport() is Window or OS.has_feature("android") or OS.has_feature("ios"):
		return
	var window: Window = get_window()
	var target: Vector2i = _original_scale_size
	if OS.has_feature("web") and _web_window != null:
		# Browser framebuffer pixels include DPR. A short landscape phone still
		# needs 48 CSS-pixel controls, not a desktop rule applied to physical pixels.
		var css_size := Vector2i(int(_web_window.innerWidth), int(_web_window.innerHeight))
		if css_size.x > css_size.y * 1.2 and css_size.x > 0 and css_size.y > 0:
			target = css_size
	elif window.size.x > window.size.y * 1.2:
		var scale: float = clampf(float(window.size.y) / 640.0, 1.0, 3.0)
		target = Vector2i(roundi(float(window.size.x) / scale), roundi(float(window.size.y) / scale))
	if window.content_scale_size != target:
		window.content_scale_size = target


func _notification(what: int) -> void:
	if _board == null:
		return
	if what == NOTIFICATION_APPLICATION_PAUSED or (what == NOTIFICATION_APPLICATION_FOCUS_OUT and (OS.has_feature("android") or OS.has_feature("ios") or OS.has_feature("web"))):
		pause_game()
	elif what == NOTIFICATION_APPLICATION_RESUMED:
		_view.invalidate_render()
		call_deferred("_layout")
	elif what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if _paused: resume_game()
		else: pause_game()


func _save_local_state() -> void:
	if _loading_state or not _shot_path.is_empty() or DisplayServer.get_name() == "headless":
		return
	var state: Dictionary = _board.snapshot()
	state["ports"] = Array(state["ports"])
	state["preferences"] = {"reduce_motion": _reduce_motion, "sound": _sound_enabled}
	var temporary: String = SAVE_PATH + ".tmp"
	var file: FileAccess = FileAccess.open(temporary, FileAccess.WRITE)
	if file == null:
		_set_guidance("Préparation gardée en mémoire.\nSauvegarde locale indisponible.", "storage_warning")
		push_warning("SLICE_LOCAL_SAVE_UNAVAILABLE")
		return
	file.store_string(JSON.stringify(state))
	file.close()
	var save_error: Error = DirAccess.rename_absolute(ProjectSettings.globalize_path(temporary), ProjectSettings.globalize_path(SAVE_PATH))
	if save_error != OK:
		_set_guidance("Préparation gardée en mémoire.\nSauvegarde locale indisponible.", "storage_warning")
		push_warning("SLICE_LOCAL_SAVE_RENAME_FAILED code=%d" % save_error)
	elif OS.has_feature("web"):
		_web_storage_available = OS.is_userfs_persistent()
		_warn_web_storage()


func _load_local_state() -> void:
	if DisplayServer.get_name() == "headless" or not OS.get_cmdline_user_args().is_empty() or not FileAccess.file_exists(SAVE_PATH):
		return
	var parser := JSON.new()
	if parser.parse(FileAccess.get_file_as_string(SAVE_PATH)) == OK and parser.data is Dictionary:
		if restore_preparation(parser.data):
			var preferences: Variant = parser.data.get("preferences", {})
			if preferences is Dictionary:
				_loading_state = true
				set_reduced_motion(preferences.get("reduce_motion", false) == true)
				_sound_enabled = preferences.get("sound", false) == true
				_sound_toggle.set_pressed_no_signal(_sound_enabled)
				_loading_state = false
			print("SLICE_LOCAL_STATE_RESTORED")


func restore_preparation(snapshot: Dictionary) -> bool:
	# Presentation half of the existing native save load. The model validates
	# atomically; this method does not write files or change the saved format.
	if _board == null or not _board.restore_snapshot(snapshot):
		return false
	_phase = "planning"
	_paused = false
	_busy_time = 0.0
	_deliveries = 0
	_restored_preparation = true
	_last_result.clear()
	_view.set_animation_paused(false)
	_view.reset_parcels()
	_view.show_invalid(-1)
	_view.sync_ports(_board.ports)
	_pause_cover.hide()
	_pause_panel.hide()
	_victory.hide()
	_set_planning_guidance(true)
	_refresh_controls()
	return true


func _play_tone(frequency: float, duration: float) -> void:
	if not _sound_enabled:
		return
	var rate: int = 22050
	var count: int = int(float(rate) * duration)
	var bytes := PackedByteArray()
	bytes.resize(count * 2)
	for index: int in range(count):
		var envelope: float = sin(PI * float(index) / float(count))
		bytes.encode_s16(index * 2, int(sin(TAU * frequency * float(index) / float(rate)) * envelope * 2800.0))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = rate
	stream.data = bytes
	var player := AudioStreamPlayer.new()
	player.stream = stream
	if OS.has_feature("web"):
		# Runtime-generated WAV tones use the engine's stream path; Web samples
		# intentionally support a narrower feature set. Sound remains optional/off.
		player.playback_type = AudioServer.PLAYBACK_TYPE_STREAM
	add_child(player)
	player.finished.connect(player.queue_free)
	player.play()


func get_board_model() -> PostalBoard: return _board
func get_board_view() -> PostalBoardView: return _view
func get_phase() -> String: return "paused" if _paused else _phase
func get_last_result() -> Dictionary: return _last_result.duplicate(true)
func get_status_text() -> String: return _status.text
func get_guidance_state() -> String: return "paused" if _paused else _guidance_state
func get_objective_text() -> String: return _subtitle.text
func get_victory_text() -> String: return _victory_text.text


func get_guidance_text() -> String:
	if _paused:
		return _pause_note.text
	if _phase == "won":
		return _victory_text.text
	return _status.text


func get_ui_controls() -> Dictionary:
	return {"pause": _buttons["pause"], "undo": _buttons["undo"], "dispatch": _buttons["dispatch"], "hint": _buttons["hint"], "restart": _buttons["restart"], "reduce_motion": _reduce_toggle, "sound": _sound_toggle, "board": _view, "pause_panel": _pause_panel, "resume": _buttons["resume"], "guidance": _status, "objective": _subtitle, "footer": _footer, "victory": _victory, "victory_text": _victory_text, "victory_replay": _buttons["victory_replay"], "header": _header, "stats": _stats_panel}


func _log_layout() -> void:
	_layout_log_queued = false
	var ratio: Vector2 = Vector2(get_window().size) / get_viewport_rect().size
	var cells: Dictionary = {}
	for index: int in range(36):
		var point: Vector2 = _view.index_to_canvas_center(index) * ratio
		cells[str(index)] = [roundi(point.x), roundi(point.y)]
	var buttons: Dictionary = {}
	for key: String in _buttons:
		var point: Vector2 = _buttons[key].get_global_rect().get_center() * ratio
		buttons[key] = [roundi(point.x), roundi(point.y)]
	for key: String in ["reduce_motion", "sound"]:
		var control: Control = _reduce_toggle if key == "reduce_motion" else _sound_toggle
		var point: Vector2 = control.get_global_rect().get_center() * ratio
		buttons[key] = [roundi(point.x), roundi(point.y)]
	var guidance_rect: Rect2 = _status.get_global_rect()
	var guidance_minimum: Vector2 = _status.get_combined_minimum_size()
	var font: Font = _status.get_theme_font("font")
	var font_rids: Array[String] = []
	for font_rid: RID in font.get_rids():
		font_rids.append(str(font_rid.get_id()))
	var guidance: Dictionary = {"state": get_guidance_state(), "visible": _status.is_visible_in_tree(), "rect": [guidance_rect.position.x, guidance_rect.position.y, guidance_rect.size.x, guidance_rect.size.y], "minimum_size": [guidance_minimum.x, guidance_minimum.y], "lines": _status.get_line_count(), "visible_lines": _status.get_visible_line_count(), "line_height": _status.get_line_height(), "font_size": _status.get_theme_font_size("font_size"), "font_rids": font_rids}
	print("SLICE_LAYOUT %s" % JSON.stringify({"cells": cells, "buttons": buttons, "phase": get_phase(), "logical_viewport": [get_viewport_rect().size.x, get_viewport_rect().size.y], "window": [get_window().size.x, get_window().size.y]}))
	print("SLICE_GUIDANCE_LAYOUT %s" % JSON.stringify({"guidance": guidance, "logical_viewport": [get_viewport_rect().size.x, get_viewport_rect().size.y], "window": [get_window().size.x, get_window().size.y]}))


func _log_metrics() -> void:
	if _metrics.is_empty(): return
	if _metrics.size() > 600: _metrics = _metrics.slice(_metrics.size() - 600)
	var sorted: PackedFloat32Array = _metrics.duplicate()
	sorted.sort()
	print("SLICE_METRICS %s" % JSON.stringify({"platform": OS.get_name(), "phase": get_phase(), "samples": sorted.size(), "measurement": "wall_clock_process_interval_after_60_frames", "p50_frame_ms": sorted[sorted.size() / 2], "p95_frame_ms": sorted[mini(sorted.size() - 1, floori(float(sorted.size()) * 0.95))], "fps": Engine.get_frames_per_second(), "draw_calls": Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME), "static_memory_bytes": Performance.get_monitor(Performance.MEMORY_STATIC)}))


func _first_frame_marker() -> void:
	if DisplayServer.get_name() == "headless": return
	await RenderingServer.frame_post_draw
	print("SLICE_FIRST_FRAME since_ready_ms=%.2f" % (float(Time.get_ticks_usec() - _ready_started_us) / 1000.0))


func _prepare_capture_scenario() -> void:
	_board.reset()
	# A debug capture starts a fresh preparation even if a local save was read in _ready.
	_restored_preparation = false
	_set_planning_guidance()
	if _shot_scenario == "won":
		for command: Dictionary in _board.level.solution_commands:
			for turn: int in range(int(command["quarter_turns"])):
				_board.rotate(int(command["index"]))
	_view.sync_ports(_board.ports)
	_refresh_controls()
	if _shot_scenario in ["won", "failed"]: dispatch()
	elif _shot_scenario == "paused": pause_game()
	elif _shot_scenario == "hint": request_hint()


func _capture_frame() -> void:
	await RenderingServer.frame_post_draw
	var image: Image = get_viewport().get_texture().get_image()
	var result: Error = image.save_png(_shot_path)
	print("SLICE_CAPTURE result=%d path=%s" % [result, _shot_path])
	get_tree().quit(0 if result == OK else 1)


func _exit_tree() -> void:
	_teardown_web_environment()
	Engine.max_fps = _old_fps
	if get_window() != null and get_viewport() is Window:
		get_window().content_scale_size = _original_scale_size


func _setup_web_environment() -> void:
	if not OS.has_feature("web"):
		return
	_web_window = JavaScriptBridge.get_interface("window")
	_web_document = JavaScriptBridge.get_interface("document")
	_web_storage_available = OS.is_userfs_persistent()
	if _web_window == null or _web_document == null:
		push_warning("SLICE_WEB_BROWSER_INTERFACE_UNAVAILABLE")
		return
	# This invisible CSS probe reads browser-provided insets; it is not a UI or a
	# substitute for the Godot canvas. Without viewport-fit=cover, insets may be zero.
	_web_safe_area_probe = _web_document.createElement("div")
	_web_safe_area_probe.style.cssText = "position:fixed;visibility:hidden;pointer-events:none;width:0;height:0;padding:env(safe-area-inset-top,0px) env(safe-area-inset-right,0px) env(safe-area-inset-bottom,0px) env(safe-area-inset-left,0px);"
	_web_document.body.appendChild(_web_safe_area_probe)
	_web_visibility_callback = JavaScriptBridge.create_callback(_on_web_visibility)
	_web_hide_callback = JavaScriptBridge.create_callback(_on_web_hidden)
	_web_show_callback = JavaScriptBridge.create_callback(_on_web_shown)
	_web_document.addEventListener("visibilitychange", _web_visibility_callback, false)
	_web_window.addEventListener("pagehide", _web_hide_callback, false)
	_web_window.addEventListener("pageshow", _web_show_callback, false)
	_web_window.addEventListener("blur", _web_hide_callback, false)
	_web_window.addEventListener("focus", _web_show_callback, false)


func _on_web_visibility(_arguments: Array) -> void:
	if _web_document != null and bool(_web_document.hidden):
		_suspend_web("visibility_hidden")
	else:
		_restore_web_surface("visibility_visible")


func _on_web_hidden(_arguments: Array) -> void:
	_suspend_web("pagehide_or_blur")


func _on_web_shown(_arguments: Array) -> void:
	_restore_web_surface("pageshow_or_focus")


func _suspend_web(reason: String) -> void:
	if _board == null:
		return
	if _paused:
		_save_local_state()
	else:
		pause_game()
	_previous_frame_us = 0
	_report_web_state(reason)


func _restore_web_surface(reason: String) -> void:
	if _board == null:
		return
	# A normal page return redraws the cached viewport but never resumes simulation
	# automatically. A genuine WebGL context loss still requires the engine's reload.
	_view.invalidate_render()
	_adapt_window_scale()
	call_deferred("_layout")
	_previous_frame_us = 0
	_report_web_state(reason)


func _warn_web_storage() -> void:
	if OS.has_feature("web") and not _web_storage_available and _status != null:
		_set_guidance("Partie gardée dans cet onglet.\nLe navigateur ne la conserve pas.", "storage_warning")


func _report_web_state(reason: String) -> void:
	# Read-only state fingerprint lets a reload test compare the restored preparation
	# without depending on an Emscripten FS implementation detail or a gameplay API.
	var state: Dictionary = {"reason": reason, "phase": get_phase(), "storage_reported_persistent": _web_storage_available,
		"secure_context": bool(_web_window.isSecureContext) if _web_window != null else false,
		"rotations": _board.rotations if _board != null else 0,
		"attempts": _board.attempts if _board != null else 0,
		"hints": _board.hints if _board != null else 0,
		"ports_hash": JSON.stringify(Array(_board.ports)).sha256_text() if _board != null else "",
		"css_width": int(_web_window.innerWidth) if _web_window != null else 0,
		"css_height": int(_web_window.innerHeight) if _web_window != null else 0,
		"device_pixel_ratio": float(_web_window.devicePixelRatio) if _web_window != null else 1.0}
	print("SLICE_WEB %s" % JSON.stringify(state))


func _teardown_web_environment() -> void:
	if not OS.has_feature("web"):
		return
	if _web_document != null and _web_visibility_callback != null:
		_web_document.removeEventListener("visibilitychange", _web_visibility_callback, false)
	if _web_window != null:
		if _web_hide_callback != null:
			_web_window.removeEventListener("pagehide", _web_hide_callback, false)
			_web_window.removeEventListener("blur", _web_hide_callback, false)
		if _web_show_callback != null:
			_web_window.removeEventListener("pageshow", _web_show_callback, false)
			_web_window.removeEventListener("focus", _web_show_callback, false)
	if _web_safe_area_probe != null:
		_web_safe_area_probe.remove()
	_web_visibility_callback = null
	_web_hide_callback = null
	_web_show_callback = null
	_web_safe_area_probe = null
	_web_document = null
	_web_window = null
