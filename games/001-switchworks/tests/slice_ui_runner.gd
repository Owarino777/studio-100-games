extends SceneTree
## Headless wiring and layout checks. GPU rendering and real Android touch are separate checks.

const SCENE_PATH: String = "res://scenes/archipel_postal.tscn"
const SIZES: Array[Vector2i] = [
	Vector2i(360, 640), Vector2i(390, 844), Vector2i(412, 915),
	Vector2i(768, 1024), Vector2i(844, 390),
]
const REQUIRED_CONTROLS: Array[String] = ["pause", "undo", "dispatch", "hint", "restart", "reduce_motion", "board"]
const INITIAL_CONTROLS: Array[String] = ["pause", "undo", "dispatch", "hint", "board"]

var _passed: int = 0
var _failed: int = 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(SCENE_PATH) as PackedScene
	_expect(packed != null, "native slice scene loads")
	if packed != null:
		for test_size: Vector2i in SIZES:
			var completed: Variant = await _test_screen(packed, test_size)
			_expect(completed == true, "screen contract completes at %s" % test_size)
	if OS.get_cmdline_user_args().has("--force-failure"):
		_expect(false, "deliberate UI failure proves non-zero process exit")
	print("SLICE_UI_TESTS passed=%d failed=%d sizes=%d" % [_passed, _failed, SIZES.size()])
	quit(1 if _failed > 0 else 0)


func _test_screen(packed: PackedScene, test_size: Vector2i) -> bool:
	var viewport := SubViewport.new()
	viewport.size = test_size
	viewport.own_world_3d = true
	root.add_child(viewport)
	var screen: Control = packed.instantiate() as Control
	viewport.add_child(screen)
	await process_frame
	await process_frame
	await process_frame
	screen.call("set_reduced_motion", true)
	var controls: Dictionary = screen.call("get_ui_controls")
	for key: String in REQUIRED_CONTROLS:
		_expect(controls.has(key) and controls[key] is Control, "%s control is exposed at %s" % [key, test_size])
	var bounds := Rect2(Vector2.ZERO, Vector2(test_size))
	for key: String in REQUIRED_CONTROLS:
		if controls.has(key) and controls[key] is Control:
			var control: Control = controls[key] as Control
			if INITIAL_CONTROLS.has(key):
				_expect(control.is_visible_in_tree(), "%s is visible at %s" % [key, test_size])
			_expect(control.size.x > 0 and control.size.y > 0, "%s has positive dimensions at %s" % [key, test_size])
			_expect(_contains_with_tolerance(bounds, control.get_global_rect()), "%s stays in the viewport at %s" % [key, test_size])
	for node: Node in screen.find_children("*", "Control", true, false):
		var control := node as Control
		if control.is_visible_in_tree():
			_expect(_contains_with_tolerance(bounds, control.get_global_rect()), "%s does not clip at %s" % [screen.get_path_to(control), test_size])
	_expect(viewport.gui_get_focus_owner() != null, "an initial keyboard focus exists at %s" % test_size)
	_expect(str(screen.call("get_phase")) == "planning", "initial phase is planning at %s" % test_size)
	_expect(not str(screen.call("get_status_text")).is_empty(), "initial instruction is non-empty")
	var board: PostalBoard = screen.call("get_board_model") as PostalBoard
	_expect(board != null and board.level != null, "native scene owns a validated board")
	if board == null:
		viewport.queue_free()
		await process_frame
		return false
	var initial: Dictionary = board.snapshot()
	# An initial dispatch must reach an explicit repairable failure, not merely change a label.
	screen.call("dispatch")
	if str(screen.call("get_phase")) == "running":
		var locked_before: Dictionary = _model(screen).snapshot()
		var editable_index: int = int(_model(screen).level.solution_commands[0]["index"])
		_expect(not bool(screen.call("rotate_cell", editable_index)), "editing is refused during resolution")
		_expect(_model(screen).snapshot() == locked_before, "input during resolution leaves the simulation state unchanged")
		screen.call("dispatch")
		_expect(_model(screen).attempts == 1, "repeated dispatch during resolution cannot duplicate an attempt")
	_expect(await _wait_for_phase(screen, ["failed"]), "invalid initial board reaches failed state")
	var result: Dictionary = screen.call("get_last_result")
	_expect(not result.get("success", true), "failed UI state is backed by a model failure")
	_expect(_model(screen).attempts == 1, "a UI dispatch counts one attempt")
	_expect(not str(screen.call("get_status_text")).is_empty(), "failure has a textual explanation")
	screen.call("restart_level")
	await process_frame
	_expect(_model(screen).ports == initial["ports"], "restart restores the authored initial rails")
	_expect(_model(screen).rotations == 0 and _model(screen).attempts == 0, "restart resets the level session counters")
	# Reproduce ScreenTouch plus its emulated primary mouse event through the GUI path.
	# Viewport.push_input itself does not perform the operating system's touch emulation.
	var first_command: Dictionary = _model(screen).level.solution_commands[0]
	var index: int = int(first_command["index"])
	var view: Control = screen.call("get_board_view") as Control
	_expect(view != null, "board view is available for picking")
	if view != null:
		var center: Vector2 = view.call("index_to_canvas_center", index)
		_expect(bounds.has_point(center), "projected rail target lies inside the viewport")
		var before_count: int = _model(screen).rotations
		await _touch(viewport, center)
		_expect(_model(screen).rotations == before_count + 1, "one synthetic touch rotates exactly one quarter-turn")
		var undo_button: BaseButton = controls["undo"] as BaseButton
		undo_button.pressed.emit()
		await process_frame
		_expect(_model(screen).ports == initial["ports"] and _model(screen).rotations == 0, "undo control restores the touch edit")
		var fixed_center: Vector2 = view.call("index_to_canvas_center", _model(screen).level.fixed_indices[0])
		await _touch(viewport, fixed_center)
		_expect(_model(screen).rotations == 0, "touching a fixed station cannot rotate it")
	var hint_button: BaseButton = controls["hint"] as BaseButton
	hint_button.pressed.emit()
	await process_frame
	_expect(_model(screen).hints == 1, "hint control reaches the model")
	_expect(_model(screen).ports == initial["ports"], "hint does not silently rotate the board")
	screen.call("restart_level")
	await process_frame
	_expect(bool(screen.call("rotate_cell", index)), "prepare a real edit before testing pause preservation")
	await process_frame
	await process_frame
	var pause_before: Dictionary = _model(screen).snapshot()
	_expect(_model(screen).rotations > 0, "pause fixture is not an untouched board")
	screen.call("pause_game")
	await process_frame
	_expect(str(screen.call("get_phase")) == "paused", "pause is an explicit lifecycle state")
	for key: String in ["pause_panel", "resume", "restart", "reduce_motion"]:
		_expect(controls.has(key) and controls[key] is Control, "%s pause control is exposed" % key)
		if controls.has(key) and controls[key] is Control:
			var control: Control = controls[key] as Control
			_expect(control.is_visible_in_tree(), "%s is visible when pause opens" % key)
			_expect(_contains_with_tolerance(bounds, control.get_global_rect()), "%s pause control fits at %s" % [key, test_size])
	var motion_toggle: BaseButton = controls["reduce_motion"] as BaseButton
	motion_toggle.button_pressed = false
	await process_frame
	_expect(not motion_toggle.button_pressed, "reduced motion can be disabled in pause")
	motion_toggle.button_pressed = true
	await process_frame
	_expect(motion_toggle.button_pressed, "reduced motion can be enabled in pause")
	var resume_button: BaseButton = controls["resume"] as BaseButton
	resume_button.pressed.emit()
	await process_frame
	_expect(_model(screen).snapshot() == pause_before, "pause and resume preserve all puzzle state")
	_expect(viewport.gui_get_focus_owner() != null, "focus returns after pause")
	screen.call("pause_game")
	await process_frame
	var restart_button: BaseButton = controls["restart"] as BaseButton
	restart_button.pressed.emit()
	await process_frame
	_expect(str(screen.call("get_phase")) == "planning" and _model(screen).ports == initial["ports"] and _model(screen).rotations == 0, "restart button leaves pause with a fresh authored board")
	var commands: Array[Dictionary] = _model(screen).level.solution_commands
	var all_moves_accepted: bool = true
	for command: Dictionary in commands:
		for turn: int in range(int(command["quarter_turns"])):
			all_moves_accepted = bool(screen.call("rotate_cell", int(command["index"]))) and all_moves_accepted
			await process_frame
			await process_frame
	_expect(all_moves_accepted, "controller accepts the authored solution")
	_expect(_model(screen).evaluate().get("success", false), "prepared native board has both valid paths")
	screen.call("dispatch")
	_expect(await _wait_for_phase(screen, ["won"]), "valid prepared board reaches won state")
	result = screen.call("get_last_result")
	_expect(result.get("success", false) and result.get("deliveries", 0) == 2, "victory is backed by two real model deliveries")
	_expect(_model(screen).attempts == 1, "solution dispatch is counted once after restart")
	viewport.queue_free()
	await process_frame
	await process_frame
	return true


func _touch(viewport: SubViewport, position: Vector2) -> void:
	var pressed := InputEventScreenTouch.new()
	pressed.index = 0
	pressed.position = position
	pressed.pressed = true
	viewport.push_input(pressed, true)
	var mouse_pressed := InputEventMouseButton.new()
	mouse_pressed.position = position
	mouse_pressed.global_position = position
	mouse_pressed.button_index = MOUSE_BUTTON_LEFT
	mouse_pressed.button_mask = MOUSE_BUTTON_MASK_LEFT
	mouse_pressed.pressed = true
	viewport.push_input(mouse_pressed, true)
	await process_frame
	var released := InputEventScreenTouch.new()
	released.index = 0
	released.position = position
	released.pressed = false
	viewport.push_input(released, true)
	var mouse_released := InputEventMouseButton.new()
	mouse_released.position = position
	mouse_released.global_position = position
	mouse_released.button_index = MOUSE_BUTTON_LEFT
	mouse_released.pressed = false
	viewport.push_input(mouse_released, true)
	await process_frame
	await process_frame


func _wait_for_phase(screen: Control, phases: Array[String]) -> bool:
	var deadline: int = Time.get_ticks_msec() + 4000
	while Time.get_ticks_msec() < deadline:
		if phases.has(str(screen.call("get_phase"))):
			return true
		await process_frame
	return false


func _model(screen: Control) -> PostalBoard:
	return screen.call("get_board_model") as PostalBoard


func _contains_with_tolerance(outer: Rect2, inner: Rect2) -> bool:
	return outer.grow(1.0).encloses(inner)


func _expect(condition: bool, description: String) -> void:
	if condition:
		_passed += 1
	else:
		_failed += 1
		push_error("SLICE_UI_FAIL %s" % description)
