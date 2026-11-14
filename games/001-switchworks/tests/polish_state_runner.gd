extends SceneTree
## P1/P2 integration contracts. These checks do not score material beauty or human game feel.

const SCENE: String = "res://scenes/archipel_postal.tscn"
const SIZES: Array[Vector2i] = [
	Vector2i(360, 640), Vector2i(390, 844), Vector2i(412, 915),
	Vector2i(768, 1024), Vector2i(844, 390),
]
const PUBLIC_CONTRACT: Array[String] = [
	"get_board_model", "get_board_view", "get_ui_controls", "get_phase",
	"get_guidance_text", "get_guidance_state", "get_objective_text", "get_victory_text",
	"restore_preparation", "dispatch", "pause_game", "resume_game", "restart_level", "set_reduced_motion",
]
var _passed: int = 0
var _failed: int = 0


class EarlyRestoredScreen:
	extends ArchipelScreen
	var saved_fixture: Dictionary = {}
	var load_hook_called: bool = false
	var restoration_accepted: bool = false
	var guidance_width_at_load: float = -1.0

	func _load_local_state() -> void:
		# This override runs from the real inherited _ready(), at the production
		# load point, instead of applying a snapshot after the first three frames.
		load_hook_called = true
		var controls: Dictionary = get_ui_controls()
		guidance_width_at_load = (controls["guidance"] as Control).size.x
		restoration_accepted = restore_preparation(saved_fixture)


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed: PackedScene = load(SCENE) as PackedScene
	_expect(packed != null, "polished scene can be loaded")
	if packed != null:
		for size: Vector2i in SIZES:
			var completed: Variant = await _test_states(packed, size)
			_expect(completed == true, "state contract completed at %s" % size)
		var completed: Variant = await _test_reception_feedback(packed)
		_expect(completed == true, "reception feedback contract completed")
		for size: Vector2i in SIZES:
			var early_completed: Variant = await _test_early_restoration(size)
			_expect(early_completed == true, "early restore/layout contract completed at %s" % size)
	if OS.get_cmdline_user_args().has("--force-failure"):
		_expect(false, "deliberate failure proves the runner exits non-zero")
	print("POLISH_STATE_TESTS passed=%d failed=%d sizes=%d" % [_passed, _failed, SIZES.size()])
	quit(1 if _failed > 0 else 0)


func _mount(packed: PackedScene, size: Vector2i) -> SubViewport:
	var viewport := SubViewport.new()
	viewport.size = size
	viewport.own_world_3d = true
	root.add_child(viewport)
	viewport.add_child(packed.instantiate())
	return viewport


func _ready_frames() -> void:
	await process_frame
	await process_frame
	await process_frame


func _has_contract(screen: Control) -> bool:
	var complete: bool = true
	for method: String in PUBLIC_CONTRACT:
		var present: bool = screen.has_method(method)
		_expect(present, "public state API exists: %s" % method)
		complete = complete and present
	return complete


func _test_states(packed: PackedScene, size: Vector2i) -> bool:
	var viewport: SubViewport = _mount(packed, size)
	await _ready_frames()
	var screen := viewport.get_child(0) as Control
	if not _has_contract(screen):
		await _unmount(viewport)
		return false
	screen.call("set_reduced_motion", true)
	var board := screen.call("get_board_model") as PostalBoard
	var controls: Dictionary = screen.call("get_ui_controls")
	var objective: String = str(screen.call("get_objective_text")).replace(" ", "")
	_expect(objective.contains("A→A") and objective.contains("B→B"), "opening objective maps both addresses explicitly")
	_expect(str(screen.call("get_guidance_state")) == "fresh", "fresh preparation is distinct from restoration")
	_expect(not _guidance(screen).is_empty(), "fresh preparation has one visible instruction")
	_check_single_guidance(controls)
	_check_actions_visible(controls, true, "fresh preparation")
	_check_layout(screen, viewport, controls)
	var initial: Dictionary = board.snapshot()
	var before_invalid_guidance: String = _guidance(screen)
	var invalid: Dictionary = initial.duplicate(true)
	invalid["attempts"] = -1
	_expect(not bool(screen.call("restore_preparation", invalid)), "invalid restoration is rejected")
	_expect(board.snapshot() == initial, "invalid restoration is atomic for model")
	_expect(_guidance(screen) == before_invalid_guidance and str(screen.call("get_guidance_state")) == "fresh", "invalid restoration cannot replace the visible instruction")

	screen.call("dispatch")
	_expect(str(screen.call("get_phase")) == "running", "dispatch enters a real running phase before resolution")
	_expect(str(screen.call("get_guidance_state")) == "running", "transport has its own instruction state")
	_expect(not _invites_rotation(_guidance(screen)), "transport does not invite an unavailable rotation")
	_expect((controls["dispatch"] as BaseButton).disabled and (controls["undo"] as BaseButton).disabled, "transport controls agree with locked editing")
	_check_actions_visible(controls, true, "transport")
	_check_single_guidance(controls)
	_expect(await _wait_phase(screen, "failed"), "initial broken route reaches failed state")
	_expect(str(screen.call("get_guidance_state")) == "failed", "failure has its own repair instruction")
	_expect(_guidance(screen) != before_invalid_guidance and not _guidance(screen).is_empty(), "failure describes a result instead of repeating opening advice")
	_expect(not (controls["dispatch"] as BaseButton).disabled, "failure remains repairable and dispatch can be retried")
	_check_actions_visible(controls, true, "repairable failure")
	_check_single_guidance(controls)

	# Restore an actually unfinished level after a failed attempt, without writing user://.
	var failed_preparation: Dictionary = board.snapshot()
	_expect(bool(screen.call("restore_preparation", failed_preparation)), "unfinished preparation can be restored")
	_expect(str(screen.call("get_phase")) == "planning", "restored preparation returns to planning, not an invented victory")
	_expect(str(screen.call("get_guidance_state")) == "restored_editable", "unfinished restoration is explicit")
	_expect(_guidance(screen).to_lower().contains("retrouv"), "unfinished restoration tells the player their preparation was found")
	_expect(board.snapshot() == failed_preparation, "guidance does not alter restored counters or rails")

	# The witness is prepared through six real domain edits; it has not been dispatched.
	var prepared: PostalBoard = _solved_board(board.level)
	var ready_snapshot: Dictionary = prepared.snapshot()
	_expect(bool(prepared.evaluate().get("success", false)), "restoration fixture is a genuinely connected board")
	_expect(bool(screen.call("restore_preparation", ready_snapshot)), "connected preparation can be restored")
	_expect(str(screen.call("get_guidance_state")) == "restored_ready", "ready restoration is distinct from unfinished restoration")
	_expect(_guidance(screen).to_lower().contains("retrouv") and _guidance(screen).to_lower().contains("expéd"), "ready restoration offers dispatch and announces recovery")
	_expect(not _invites_rotation(_guidance(screen)), "ready restoration does not invite the player to disturb a valid route")
	_expect(board.snapshot() == ready_snapshot, "ready restoration is a presentation change, not a model edit")
	var ready_guidance: String = _guidance(screen)
	var invalid_ready: Dictionary = ready_snapshot.duplicate(true)
	invalid_ready["ports"] = PackedInt32Array([0])
	_expect(not bool(screen.call("restore_preparation", invalid_ready)), "malformed ports cannot replace a ready preparation")
	_expect(board.snapshot() == ready_snapshot and _guidance(screen) == ready_guidance, "invalid restore preserves ready board and message together")
	screen.call("pause_game")
	_expect(str(screen.call("get_guidance_state")) == "paused", "pause exposes a distinct guidance state")
	_expect(not _invites_rotation(_guidance(screen)), "pause does not advertise a locked editing gesture")
	_check_single_guidance(controls)
	screen.call("resume_game")
	_expect(str(screen.call("get_guidance_state")) == "restored_ready", "resume restores the ready instruction instead of the generic opening")
	_expect(board.snapshot() == ready_snapshot, "pause and resume preserve restored preparation")

	screen.call("dispatch")
	_expect(not _invites_rotation(_guidance(screen)), "second dispatch still uses transport guidance")
	_expect(await _wait_phase(screen, "won"), "valid restored preparation delivers both parcels")
	_expect(str(screen.call("get_guidance_state")) == "won", "victory uses a distinct visible instruction")
	var victory: String = str(screen.call("get_victory_text")).to_lower()
	_expect(not victory.contains("(s)"), "victory contains no development plural placeholder")
	_expect(victory.contains("1 essai") and not victory.contains("1 essais"), "first dispatch is written with a natural singular")
	_expect(not _invites_rotation(_guidance(screen)), "victory offers no impossible rotation")
	_check_single_guidance(controls)
	_expect((controls["dispatch"] as BaseButton).disabled and (controls["hint"] as BaseButton).disabled, "victory still locks hidden editing commands")
	_check_actions_visible(controls, false, "victory")
	if controls.has("victory_replay"):
		_expect(not (controls["victory_replay"] as BaseButton).disabled, "local receipt feedback does not disable replay")
	_check_layout(screen, viewport, controls)
	screen.call("restart_level")
	_expect(board.snapshot() == initial, "replay restores original topology and counters")
	_expect(str(screen.call("get_guidance_state")) == "fresh", "replay returns to a fresh opening instruction")
	_check_actions_visible(controls, true, "replay preparation")
	await _unmount(viewport)
	return true


func _test_reception_feedback(packed: PackedScene) -> bool:
	var viewport: SubViewport = _mount(packed, Vector2i(390, 844))
	await _ready_frames()
	var screen := viewport.get_child(0) as Control
	if not _has_contract(screen):
		await _unmount(viewport)
		return false
	var view: Control = screen.call("get_board_view") as Control
	_expect(view.has_method("get_reception_state"), "view exposes read-only receipt state for both addresses")
	if not view.has_method("get_reception_state"):
		await _unmount(viewport)
		return false
	var board: PostalBoard = screen.call("get_board_model") as PostalBoard
	var prepared: PostalBoard = _solved_board(board.level)
	var ready: Dictionary = prepared.snapshot()
	screen.call("set_reduced_motion", false)
	_expect(bool(screen.call("restore_preparation", ready)), "normal animation starts from valid preparation")
	_check_receipts(view, false)
	screen.call("dispatch")
	var dispatched: Dictionary = board.snapshot()
	_expect(await _wait_phase(screen, "won"), "normal-motion route reaches actual victory")
	await create_timer(0.65).timeout
	_check_receipts(view, true)
	_expect(board.snapshot() == dispatched, "normal feedback cannot alter logical ports, counters or result")

	# Replaying before a new arrival tween settles must cancel it, not leave a stamp or hidden parcel.
	_expect(bool(screen.call("restore_preparation", ready)), "normal route can be prepared again")
	screen.call("dispatch")
	_expect(await _wait_phase(screen, "won"), "second normal route completes")
	screen.call("restart_level")
	await create_timer(0.45).timeout
	_check_receipts(view, false)
	_expect(board.rotations == 0 and board.attempts == 0, "replay during feedback starts a clean level session")
	_expect(bool(screen.call("restore_preparation", ready)), "normal receipt can be replayed before testing a preference change")
	screen.call("dispatch")
	_expect(await _wait_phase(screen, "won"), "normal route reaches the receipt before the preference change")
	var before_motion_change: Dictionary = board.snapshot()
	screen.call("pause_game")
	screen.call("set_reduced_motion", true)
	_check_receipts(view, true)
	screen.call("resume_game")
	_expect(board.snapshot() == before_motion_change, "reducing movement during a paused receipt changes only presentation")

	# Reduced mode reaches the same received state immediately, without waiting on a tween.
	screen.call("set_reduced_motion", true)
	_expect(bool(screen.call("restore_preparation", ready)), "reduced-motion preparation is restored")
	screen.call("dispatch")
	_expect(await _wait_phase(screen, "won"), "reduced motion still delivers two parcels")
	_check_receipts(view, true)
	var reduced_snapshot: Dictionary = board.snapshot()
	screen.call("pause_game")
	screen.call("resume_game")
	_check_receipts(view, true)
	_expect(board.snapshot() == reduced_snapshot, "pause/resume cannot erase received state or alter logical result")

	# A real failed first attempt followed by correction produces a natural plural at victory.
	screen.call("restart_level")
	screen.call("dispatch")
	_expect(await _wait_phase(screen, "failed"), "plural fixture begins with an actual failed dispatch")
	var correction := PostalBoard.new(board.level)
	_expect(correction.restore_snapshot(board.snapshot()), "failed snapshot can be corrected through legal edits")
	for move: Dictionary in board.level.solution_commands:
		for turn: int in int(move["quarter_turns"]):
			_expect(correction.rotate(int(move["index"])), "legal correction contributes to the plural fixture")
	_expect(bool(screen.call("restore_preparation", correction.snapshot())), "corrected preparation preserves the failed attempt")
	screen.call("dispatch")
	_expect(await _wait_phase(screen, "won"), "corrected second attempt wins")
	_expect(str(screen.call("get_victory_text")).to_lower().contains("2 essais"), "second attempt is written with a natural plural")
	await _unmount(viewport)
	return true


func _test_early_restoration(size: Vector2i) -> bool:
	var level: PostalLevel = PostalLevel.load_default()
	_expect(level != null, "early-restore fixture uses the real level")
	if level == null:
		return false
	var unfinished := PostalBoard.new(level)
	unfinished.simulate()
	var prepared: PostalBoard = _solved_board(level)
	var invalid: Dictionary = prepared.snapshot()
	invalid["ports"] = PackedInt32Array([0])
	var cases: Array[Dictionary] = [
		{"name": "unfinished", "snapshot": unfinished.snapshot(), "accepted": true, "guidance": "restored_editable"},
		{"name": "ready", "snapshot": prepared.snapshot(), "accepted": true, "guidance": "restored_ready"},
		{"name": "invalid", "snapshot": invalid, "accepted": false, "guidance": "fresh"},
	]
	for fixture: Dictionary in cases:
		var viewport := SubViewport.new()
		viewport.size = size
		viewport.own_world_3d = true
		root.add_child(viewport)
		var screen := EarlyRestoredScreen.new()
		screen.saved_fixture = (fixture["snapshot"] as Dictionary).duplicate(true)
		screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		screen.size = Vector2(size)
		viewport.add_child(screen)
		var context: String = "early %s at %s" % [fixture["name"], size]
		_expect(screen.load_hook_called, context + " invokes loading inside the real _ready")
		_expect(screen.restoration_accepted == bool(fixture["accepted"]), context + " accepts or rejects the real snapshot contract")
		_expect(screen.get_guidance_state() == str(fixture["guidance"]), context + " selects the right initial instruction")
		if bool(fixture["accepted"]):
			_expect(screen.get_board_model().snapshot() == fixture["snapshot"], context + " preserves the loaded preparation")
			_expect(screen.get_guidance_text().to_lower().contains("retrouv"), context + " tells the player their preparation was restored")
		else:
			_expect(screen.get_board_model().snapshot() == PostalBoard.new(level).snapshot(), context + " leaves an invalid load at the clean initial state")
		_check_guidance_box(screen, size, context + " first layout")
		await _ready_frames()
		_check_guidance_box(screen, size, context + " settled layout")
		screen.restart_level()
		_check_guidance_box(screen, size, context + " restart")
		screen.set_reduced_motion(true)
		screen.dispatch()
		_check_guidance_box(screen, size, context + " running")
		_expect(not _invites_rotation(screen.get_guidance_text()), context + " running never advertises a locked gesture")
		_expect(await _wait_phase(screen, "failed"), context + " broken initial route fails normally")
		_check_guidance_box(screen, size, context + " failure")
		print("POLISH_EARLY_LOAD case=%s size=%s load_width=%s" % [fixture["name"], size, screen.guidance_width_at_load])
		await _unmount(viewport)
	return true


func _check_guidance_box(screen: ArchipelScreen, size: Vector2i, context: String) -> void:
	var controls: Dictionary = screen.get_ui_controls()
	var label: Label = controls["guidance"] as Label
	var board: Control = controls["board"] as Control
	var dispatch_button: Control = controls["dispatch"] as Control
	var stats: Control = controls["stats"] as Control
	var wide: bool = float(size.x) > float(size.y) * 1.2
	var nominal_height: float = 54.0 if wide else 40.0
	var maximum_height: float = 54.0
	var rect: Rect2 = label.get_global_rect()
	var bounds := Rect2(Vector2.ZERO, Vector2(size))
	_expect(label.is_visible_in_tree(), context + " has a visible guidance label")
	_expect(label.size.y >= nominal_height - 1.0 and label.size.y <= maximum_height + 1.0, "%s keeps a bounded 40–54-unit box; actual=%s" % [context, rect])
	_expect(label.get_combined_minimum_size().y <= maximum_height + 1.0, "%s has no inflated hidden-label minimum: %s" % [context, label.get_combined_minimum_size()])
	_expect(label.get_combined_minimum_size().y <= label.size.y + 0.1, context + " reserves the actual two-line font minimum")
	_expect(label.get_line_count() <= 2, "%s uses at most two guidance lines, actual=%d" % [context, label.get_line_count()])
	_expect(bounds.grow(1.0).encloses(rect), "%s instruction stays in the screen: %s" % [context, rect])
	_expect(rect.position.y >= stats.get_global_rect().end.y + 3.9, "%s leaves at least four units below stats: guidance=%s stats=%s" % [context, rect, stats.get_global_rect()])
	_expect(rect.end.y <= dispatch_button.get_global_rect().position.y - 15.0, context + " is separated from bottom actions")
	if wide:
		_expect(not rect.intersects(board.get_global_rect()), context + " does not cover the landscape board")
	else:
		_expect(rect.end.y <= board.get_global_rect().position.y - 1.0, context + " remains above the portrait board")
		_expect(rect.end.y <= board.get_global_rect().position.y - 3.9, "%s leaves four units above the portrait board: guidance=%s board=%s" % [context, rect, board.get_global_rect()])


func _check_receipts(view: Control, received: bool) -> void:
	for label: String in ["A", "B"]:
		var state: Dictionary = view.call("get_reception_state", label)
		_expect(state.has_all(["seal_visible", "lid_rotation", "parcel_scale", "parcel_visible", "received"]), "receipt API contains complete visible state for %s" % label)
		_expect(bool(state.get("received", not received)) == received, "received state matches the address %s" % label)
		_expect(bool(state.get("seal_visible", not received)) == received, "local stamp matches delivered state for %s" % label)
		_expect(bool(state.get("parcel_visible", received)) != received, "parcel is visible at departure and inside mailbox after delivery %s" % label)
		var rotation: Vector3 = state.get("lid_rotation", Vector3.ONE)
		var scale_value: Vector3 = state.get("parcel_scale", Vector3.ZERO)
		_expect(rotation.is_zero_approx(), "reception lid rests closed for %s" % label)
		_expect(scale_value.is_equal_approx(Vector3.ONE), "feedback cannot leave scale drift for %s" % label)


func _check_single_guidance(controls: Dictionary) -> void:
	_expect(controls.has("footer"), "legacy footer remains observable for the redundancy check")
	if controls.get("footer") is Label:
		var footer := controls["footer"] as Label
		_expect(footer.text.is_empty() and not footer.is_visible_in_tree(), "there is no contradictory second instruction at the bottom")


func _check_actions_visible(controls: Dictionary, expected: bool, context: String) -> void:
	for key: String in ["undo", "dispatch", "hint"]:
		var action: Control = controls[key] as Control
		_expect(action.is_visible_in_tree() == expected, "%s shows preparation action %s only when appropriate" % [context, key])


func _check_layout(screen: Control, viewport: SubViewport, controls: Dictionary) -> void:
	var bounds := Rect2(Vector2.ZERO, Vector2(viewport.size))
	for key: String in ["pause", "undo", "dispatch", "hint"]:
		var control: Control = controls[key] as Control
		_expect(control.size.x >= 48.0 and control.size.y >= 48.0, "%s keeps a 48-unit nominal touch target" % key)
		_expect(bounds.grow(1.0).encloses(control.get_global_rect()), "%s is inside the test viewport" % key)
		if key != "pause":
			_expect(control.get_global_rect().end.y <= bounds.end.y - 15.0, "%s stays clear of the lower 16-unit inset" % key)
	for node: Node in screen.find_children("*", "Control", true, false):
		var control := node as Control
		if control.is_visible_in_tree():
			_expect(bounds.grow(1.0).encloses(control.get_global_rect()), "visible %s fits at %s: rect=%s bounds=%s phase=%s" % [screen.get_path_to(control), viewport.size, control.get_global_rect(), bounds, screen.call("get_phase")])


func _solved_board(level: PostalLevel) -> PostalBoard:
	var board := PostalBoard.new(level)
	for move: Dictionary in level.solution_commands:
		for turn: int in int(move["quarter_turns"]):
			_expect(board.rotate(int(move["index"])), "authored witness consists only of legal rotations")
	return board


func _guidance(screen: Control) -> String:
	return str(screen.call("get_guidance_text"))


func _invites_rotation(text: String) -> bool:
	var lower: String = text.to_lower()
	return lower.contains("touchez") or lower.contains("tournez")


func _wait_phase(screen: Control, phase: String) -> bool:
	var deadline: int = Time.get_ticks_msec() + 4500
	while Time.get_ticks_msec() < deadline:
		if str(screen.call("get_phase")) == phase:
			return true
		await process_frame
	return false


func _unmount(viewport: SubViewport) -> void:
	viewport.queue_free()
	await process_frame
	await process_frame


func _expect(condition: bool, message: String) -> void:
	if condition:
		_passed += 1
	else:
		_failed += 1
		push_error("POLISH_STATE_FAIL " + message)
