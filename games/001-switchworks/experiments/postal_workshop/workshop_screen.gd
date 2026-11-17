class_name PostalWorkshopScreen
extends "res://experiments/littoral/littoral_screen.gd"
## Same controller and save contract; native Container UI replaces only presentation.

const HUD = preload("res://ui/workshop/postal_hud.tscn")
const STATE = preload("res://ui/workshop/presentation_state.gd")
const DEFAULT_THEME: Theme = preload("res://ui/workshop/workshop_theme.tres")
const UNDO_ICON: Texture2D = preload("res://ui/workshop/icons/undo.svg")
const HINT_ICON: Texture2D = preload("res://ui/workshop/icons/hint.svg")
const SEND_ICON: Texture2D = preload("res://ui/workshop/icons/send.svg")
const REPLAY_ICON: Texture2D = preload("res://ui/workshop/icons/replay.svg")
@export_range(1.0, 2.0) var text_scale: float = 1.0
var _hud: Control
var _safe_center: CenterContainer
var _stack: VBoxContainer
var _play_grid: GridContainer
var _board_aspect: AspectRatioContainer
var _header_margin: MarginContainer
var _header_stack: VBoxContainer
var _header_row: HBoxContainer
var _info_margin: MarginContainer
var _context_slot: PanelContainer
var _stats_holder: Control
var _pause_center: CenterContainer
var _pause_heading: Label
var _receipts_complete: bool = false
var _wide_layout: bool = false


func _ready() -> void:
	if OS.has_feature("android"):
		DisplayServer.screen_set_orientation(DisplayServer.SCREEN_SENSOR)
	super._ready()


func _build_ui() -> void:
	_hud = HUD.instantiate() as Control
	add_child(_hud)
	theme = DEFAULT_THEME if is_equal_approx(text_scale, 1.0) else WorkshopTheme.make(text_scale)
	_hud.theme = theme
	(_hud.get_node("Background") as ColorRect).color = WorkshopTheme.TOKENS.background
	_safe_center = _hud.get_node("SafeCenter")
	_stack = _safe_center.get_node("Stack")
	_header_margin = _stack.get_node("HeaderMargin")
	_header = _header_margin.get_node("Header")
	_header_stack = _header.get_node("HeaderStack")
	_header_row = _header_stack.get_node("Row")
	_eyebrow = _header_row.get_node("Brand")
	_title = _eyebrow
	_subtitle = _header_stack.get_node("Objective")
	_stats["deliveries"] = _header_row.get_node("Progress/Column/Value")
	_buttons["pause"] = _header_row.get_node("Pause")
	_buttons["pause"].pressed.connect(pause_game)
	_play_grid = _stack.get_node("PlayGrid")
	_board_aspect = _play_grid.get_node("BoardAspect")
	_view = _create_board_view()
	_board_aspect.add_child(_view)
	_view.cell_pressed.connect(rotate_cell)
	(_view as WorkshopBoardView).receipts_finished.connect(_on_receipts_finished)
	_view.accessibility_name = "Plateau de six lignes et six colonnes"
	_view.accessibility_description = "Touchez une voie pour la tourner. Clavier : flèches, puis Entrée."
	_info_margin = _play_grid.get_node("InfoMargin")
	var info: VBoxContainer = _info_margin.get_node("Info")
	_context_slot = info.get_node("Context")
	_context_slot.custom_minimum_size.y = ceilf(56 * text_scale)
	_status = _context_slot.get_node("Guidance")
	_victory = _context_slot.get_node("Result")
	_victory_text = _victory.get_node("Text")
	_stats_holder = info.get_node("StatsHolder")
	_stats_holder.custom_minimum_size.y = ceilf(24 * text_scale)
	_stats_panel = _stats_holder.get_node("Stats")
	_stats["rotations"] = _stats_panel.get_node("Row/Rotations")
	_stats["attempts"] = _stats_panel.get_node("Row/Attempts")
	_buttons["undo"] = info.get_node("Actions/Undo")
	_buttons["dispatch"] = info.get_node("Actions/Primary")
	_buttons["hint"] = info.get_node("Actions/Hint")
	_buttons["victory_replay"] = _buttons["dispatch"]
	_buttons["undo"].pressed.connect(undo_move)
	_buttons["dispatch"].pressed.connect(_primary_action)
	_buttons["hint"].pressed.connect(request_hint)
	if text_scale <= 1.0:
		_buttons["undo"].icon = UNDO_ICON
		_buttons["hint"].icon = HINT_ICON
	_footer = Label.new()
	_footer.hide()
	add_child(_footer)
	_pause_cover = _hud.get_node("PauseCover")
	_pause_center = _hud.get_node("PauseCenter")
	_pause_panel = _pause_center.get_node("PausePanel")
	var options: VBoxContainer = _pause_panel.get_node("Column")
	_pause_heading = options.get_node("Heading")
	_pause_note = options.get_node("Note")
	_buttons["resume"] = options.get_node("Resume")
	_buttons["restart"] = options.get_node("Restart")
	_reduce_toggle = options.get_node("ReduceMotion")
	_sound_toggle = options.get_node("Sound")
	_buttons["resume"].pressed.connect(resume_game)
	_buttons["restart"].pressed.connect(restart_level)
	_reduce_toggle.toggled.connect(set_reduced_motion)
	_sound_toggle.toggled.connect(_set_sound_enabled)
	# Hidden wrapping labels otherwise shape at width zero before the first
	# Container sort and can briefly report a screen-sized minimum height.
	var content_width: float = maxf(100, _safe_rect().size.x - WorkshopTheme.TOKENS.edge * 2)
	for label: Label in [_status, _victory_text, _subtitle]: label.size.x = content_width
	_pause_note.size.x = maxf(100, minf(340, _safe_rect().size.x - 32) - 40)
	var focus: Array[Control] = [_buttons["resume"], _buttons["restart"], _reduce_toggle, _sound_toggle]
	for i in focus.size():
		focus[i].focus_next = focus[(i+1)%focus.size()].get_path()
		focus[i].focus_previous = focus[(i+focus.size()-1)%focus.size()].get_path()
	for key: String in ["undo", "dispatch", "hint", "pause", "resume", "restart"]:
		_buttons[key].accessibility_name = _buttons[key].text
	info.minimum_size_changed.connect(_queue_layout)
	_header_stack.minimum_size_changed.connect(_queue_layout)
	# Containers can finish rearranging after the first-frame marker. Publish the
	# actual post-sort coordinates used by native/browser touch QA, not stale ones.
	_view.item_rect_changed.connect(_queue_layout_log)
	for key: String in ["pause", "dispatch", "undo", "hint", "resume", "restart"]:
		_buttons[key].item_rect_changed.connect(_queue_layout_log)
	call_deferred("_layout")


func _create_board_view() -> PostalBoardView:
	return WorkshopBoardView.new()


func _process(delta: float) -> void:
	var was_busy: bool = _busy_time > 0
	super._process(delta)
	if was_busy and _busy_time <= 0: _refresh_controls()


func _adapt_window_scale() -> void:
	if OS.has_feature("android"):
		var window: Window = get_window()
		var dpi: int = DisplayServer.screen_get_dpi()
		var density: float = float(dpi) / 160.0 if dpi > 0 else float(mini(window.size.x, window.size.y)) / 360.0
		var target := Vector2i(roundi(window.size.x / density), roundi(window.size.y / density))
		if window.content_scale_size != target: window.content_scale_size = target
		return
	super._adapt_window_scale()


func _queue_layout() -> void:
	call_deferred("_layout")


func _layout() -> void:
	if _play_grid == null: return
	var safe: Rect2 = _safe_rect()
	var wide: bool = safe.size.x > safe.size.y * 1.2
	if wide != _wide_layout:
		_wide_layout = wide
		_subtitle.reparent(_header_row if wide else _header_stack)
		if wide: _header_row.move_child(_subtitle, 1)
		_subtitle.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for container: Control in [_safe_center, _pause_center]:
		container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		container.offset_left = safe.position.x
		container.offset_top = safe.position.y
		container.offset_right = safe.end.x - get_viewport_rect().size.x
		container.offset_bottom = safe.end.y - get_viewport_rect().size.y
	_play_grid.columns = 2 if wide else 1
	_stack.custom_minimum_size.x = safe.size.x
	var header_height: float = _header_margin.get_combined_minimum_size().y
	var info_height: float = _info_margin.get_combined_minimum_size().y
	var remaining: float = maxf(120, safe.size.y - header_height - 8 - (0 if wide else info_height + 8))
	var width: float = minf(safe.size.x * 0.54 if wide else safe.size.x, remaining * _board_aspect.ratio)
	var desired := Vector2(width, width / _board_aspect.ratio)
	if _board_aspect.custom_minimum_size != desired: _board_aspect.custom_minimum_size = desired
	_pause_panel.custom_minimum_size.x = minf(340, safe.size.x - 32)
	_pause_cover.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)


func _primary_action() -> void:
	if _phase == "won": restart_level()
	else: dispatch()


func _set_guidance(text: String, state: String) -> void:
	super._set_guidance(STATE.copy_for(text, state), state)
	_refresh_controls()


func _refresh_controls() -> void:
	if _board == null or _context_slot == null: return
	var state: Dictionary = STATE.derive(self, _receipts_complete)
	_stats["rotations"].text = _format_counter(_board.rotations)
	_stats["attempts"].text = _format_counter(_board.attempts)
	_stats["deliveries"].text = "%d / 2" % _deliveries
	_buttons["undo"].visible = state["show_secondary_actions"]
	_buttons["hint"].visible = state["show_secondary_actions"]
	_buttons["dispatch"].show()
	_buttons["dispatch"].text = state["primary_copy"]
	_buttons["dispatch"].accessibility_name = state["primary_copy"]
	_buttons["dispatch"].icon = (REPLAY_ICON if _phase == "won" else SEND_ICON) if text_scale <= 1.0 else null
	_buttons["undo"].disabled = not state["undo_enabled"]
	_buttons["hint"].disabled = not state["hint_enabled"]
	_buttons["dispatch"].disabled = not state["primary_enabled"]
	for key: String in ["undo", "hint", "dispatch", "pause"]:
		_buttons[key].focus_mode = Control.FOCUS_NONE if _paused else Control.FOCUS_ALL
	_buttons["pause"].disabled = _paused
	_buttons["resume"].text = state["resume_copy"]
	_pause_heading.text = state["pause_heading"]
	_pause_note.text = state["pause_copy"]
	_view.mouse_filter = Control.MOUSE_FILTER_STOP if state["board_enabled"] else Control.MOUSE_FILTER_IGNORE
	_view.focus_mode = Control.FOCUS_ALL if state["board_enabled"] else Control.FOCUS_NONE
	_stats_panel.visible = state["show_stats"]
	_victory.visible = state["show_result"]
	_status.visible = not _paused and not state["show_result"]
	if _phase == "won" and not _receipts_complete: _status.text = "Réception des deux colis…"
	_footer.hide()
	(_view as WorkshopBoardView).set_route_ready(state["ready"])
	call_deferred("_layout")


func restart_level() -> void:
	_receipts_complete = false
	super.restart_level()


func dispatch() -> void:
	if _paused or _phase in ["running", "won"] or _busy_time > 0: return
	_receipts_complete = false
	super.dispatch()


func _on_receipts_finished() -> void:
	_receipts_complete = true
	_refresh_controls()
	print("POSTAL_UI_RECEIPTS_FINISHED")


func get_presentation_state() -> Dictionary:
	return STATE.derive(self, _receipts_complete)


func _log_layout() -> void:
	super._log_layout()
	if _hud == null: return
	var ratio: Vector2 = Vector2(get_window().size) / get_viewport_rect().size
	var dpi: int = DisplayServer.screen_get_dpi()
	var targets: Dictionary = {}
	for key: String in ["undo", "dispatch", "hint", "pause", "resume", "restart"]:
		var control: Button = _buttons[key]
		var pixel_size: Vector2 = control.size * ratio
		targets[key] = {"visible": control.is_visible_in_tree(), "pixels": [pixel_size.x, pixel_size.y],
			"dp_if_android": [pixel_size.x * 160.0 / maxi(dpi,1), pixel_size.y * 160.0 / maxi(dpi,1)] if OS.has_feature("android") else []}
	print("POSTAL_UI_LAYOUT " + JSON.stringify({"phase": get_phase(), "dpi_reported": dpi,
		"logical": [get_viewport_rect().size.x, get_viewport_rect().size.y], "targets": targets,
		"text_scale": text_scale, "notes": "Godot logical sizes are not automatically physical pt/dp; Android numbers use reported DPI; physical comfort untested"}))
