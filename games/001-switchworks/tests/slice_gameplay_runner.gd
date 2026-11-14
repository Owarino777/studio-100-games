extends SceneTree
## Behavioural contract for the experimental postal routing level.

const LevelModel = preload("res://scripts/domain/postal_level.gd")
const BoardModel = preload("res://scripts/domain/postal_board.gd")
const LEVEL_PATH := "res://data/archipel_double_flux.json"
const PROPERTY_TRIALS: int = 1000

var _passed: int = 0
var _failed: int = 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var tests: Array[StringName] = [
		&"_test_level_boundary", &"_test_initial_and_solution", &"_test_rejected_moves",
		&"_test_snapshots_and_restore", &"_test_hint_undo_reset", &"_test_error_routes",
		&"_test_rotation_properties",
	]
	for test_name: StringName in tests:
		var completed: Variant = call(test_name)
		_expect(completed == true, "%s completed without runtime error" % test_name)
	if OS.get_cmdline_user_args().has("--force-failure"):
		_expect(false, "deliberate failure proves non-zero process exit")
	print("SLICE_GAMEPLAY_TESTS passed=%d failed=%d undo_trials=%d" % [_passed, _failed, PROPERTY_TRIALS])
	quit(1 if _failed > 0 else 0)


func _test_level_boundary() -> bool:
	var raw: Dictionary = _default_data()
	_expect(LevelModel.validate_data(raw).is_empty(), "authored level passes input validation")
	var level: PostalLevel = LevelModel.load_default()
	_expect(level != null, "default level loads")
	if level == null:
		return false
	_expect(level.initial_ports.size() == 36, "level contains exactly 36 cells")
	_expect(level.source_indices.size() == 2 and level.destination_indices.size() == 2, "two labelled sources and destinations")
	_expect(level.fixed_indices.size() == 4, "four fixed station cells")
	_expect(level.solution_commands.size() >= 4, "representative level requires several authored edits")
	var detached: PostalLevel = LevelModel.from_dictionary(raw)
	var original_port: int = detached.initial_ports[7]
	raw["initial_grid"][1][1] = ""
	_expect(detached.initial_ports[7] == original_port, "level detaches input arrays")
	var malformed: Array[Dictionary] = []
	var invalid: Dictionary = _default_data()
	invalid["schema_version"] = 99
	malformed.append(invalid)
	invalid = _default_data()
	invalid["initial_grid"] = [["EW"]]
	malformed.append(invalid)
	invalid = _default_data()
	invalid["initial_grid"][1][1] = "NES"
	malformed.append(invalid)
	invalid = _default_data()
	invalid["sources"]["A"] = [-1, 0]
	malformed.append(invalid)
	invalid = _default_data()
	invalid["destinations"]["B"] = invalid["destinations"]["A"].duplicate()
	malformed.append(invalid)
	invalid = _default_data()
	invalid["solution_commands"] = [{"index": -1, "quarter_turns": 1}]
	malformed.append(invalid)
	invalid = _default_data()
	invalid["reference_rotations"] = -1
	malformed.append(invalid)
	invalid = _default_data()
	invalid["sources"].erase("B")
	malformed.append(invalid)
	for bad_level: Dictionary in malformed:
		_expect(not LevelModel.validate_data(bad_level).is_empty(), "malformed input has explicit validation errors")
		_expect(LevelModel.from_dictionary(bad_level) == null, "malformed level is refused without partial construction")
	return true


func _test_initial_and_solution() -> bool:
	var level: PostalLevel = LevelModel.load_default()
	var board: PostalBoard = BoardModel.new(level)
	var before: String = _state_hash(board)
	var initial: Dictionary = board.evaluate()
	_expect(not initial.get("success", true), "initial puzzle is not already solved")
	_expect(board.attempts == 0, "evaluate does not count a dispatch")
	_expect(_state_hash(board) == before, "evaluate leaves the complete state unchanged")
	_expect(JSON.stringify(initial) == JSON.stringify(board.evaluate()), "same state yields identical events and result")
	_expect(_apply_solution(board, level), "authored solution commands are accepted")
	var solved_before: String = _state_hash(board)
	var result: Dictionary = board.evaluate()
	_expect(result.get("success", false), "solution delivers both parcels")
	_expect(result.get("reason", "") == "delivered", "success has a stable result code")
	_expect(result.get("deliveries", 0) == 2, "both deliveries are accounted for")
	_expect(board.attempts == 0 and _state_hash(board) == solved_before, "solved evaluation is still pure")
	var paths: Dictionary = result.get("paths", {})
	for label: String in ["A", "B"]:
		var path: PackedInt32Array = paths.get(label, PackedInt32Array())
		_expect(not path.is_empty(), "path exists for parcel %s" % label)
		if not path.is_empty():
			_expect(path[0] == level.source_indices[label], "%s path begins at its source" % label)
			_expect(path[path.size() - 1] == level.destination_indices[label], "%s path ends at its own destination" % label)
	_expect(_count_events(result.get("events", []), "delivered") == 2, "view receives one delivery event per parcel")
	var dispatched: Dictionary = board.simulate()
	_expect(dispatched.get("success", false) and board.attempts == 1, "dispatch counts one real attempt")
	_expect(JSON.stringify(dispatched) == JSON.stringify(result), "dispatch and pure evaluation resolve the same route")
	var path_copy: PackedInt32Array = paths.get("A", PackedInt32Array())
	path_copy[0] = 35
	var fresh_result: Dictionary = board.evaluate()
	var fresh_paths: Dictionary = fresh_result.get("paths", {})
	var fresh_a: PackedInt32Array = fresh_paths.get("A", PackedInt32Array())
	_expect(fresh_a[0] == level.source_indices["A"], "result path arrays do not corrupt later evaluations")
	return true


func _test_rejected_moves() -> bool:
	var level: PostalLevel = LevelModel.load_default()
	var board: PostalBoard = BoardModel.new(level)
	var before: String = _state_hash(board)
	var rejected: PackedInt32Array = PackedInt32Array([-1, 36, 0])
	for fixed_index: int in level.fixed_indices:
		rejected.append(fixed_index)
	for index: int in rejected:
		_expect(not board.can_rotate(index), "cell %d cannot be rotated" % index)
		_expect(not board.rotate(index), "invalid/fixed/empty rotation %d is refused" % index)
		_expect(_state_hash(board) == before, "refused move %d has no effect" % index)
	_expect(not board.undo(), "rejected moves do not create undo history")
	return true


func _test_snapshots_and_restore() -> bool:
	var level: PostalLevel = LevelModel.load_default()
	var board: PostalBoard = BoardModel.new(level)
	var pristine: Dictionary = board.snapshot()
	var saved_ports: PackedInt32Array = pristine["ports"]
	var original: int = board.ports[7]
	saved_ports[7] = 0
	_expect(board.ports[7] == original, "snapshot ports are detached from the board")
	var before: String = _state_hash(board)
	var malformed: Array[Dictionary] = []
	var invalid: Dictionary = board.snapshot()
	invalid.erase("level_id")
	malformed.append(invalid)
	invalid = board.snapshot()
	invalid["level_id"] = "another-level"
	malformed.append(invalid)
	invalid = board.snapshot()
	invalid["schema_version"] = 999
	malformed.append(invalid)
	invalid = board.snapshot()
	invalid["ports"] = PackedInt32Array([1, 2])
	malformed.append(invalid)
	invalid = board.snapshot()
	invalid["ports"][level.fixed_indices[0]] = 3
	malformed.append(invalid)
	invalid = board.snapshot()
	invalid["rotations"] = -1
	malformed.append(invalid)
	invalid = board.snapshot()
	invalid["attempts"] = 1.5
	malformed.append(invalid)
	for bad_snapshot: Dictionary in malformed:
		_expect(not board.restore_snapshot(bad_snapshot), "invalid/foreign snapshot is rejected")
		_expect(_state_hash(board) == before, "invalid restoration is atomic")
	var first_command: Dictionary = level.solution_commands[0]
	board.rotate(int(first_command["index"]))
	board.simulate()
	var snapshot: Dictionary = board.snapshot()
	var restored: PostalBoard = BoardModel.new(LevelModel.load_default())
	_expect(restored.restore_snapshot(snapshot), "valid snapshot restores on its own level")
	_expect(_state_hash(restored) == _state_hash(board), "restored logical state and counters match")
	_expect(not restored.undo(), "restoration does not fabricate edit history")
	var serialized: Variant = JSON.parse_string(JSON.stringify(snapshot))
	var from_json: PostalBoard = BoardModel.new(LevelModel.load_default())
	_expect(serialized is Dictionary and from_json.restore_snapshot(serialized as Dictionary), "JSON round-trip snapshot restores")
	_expect(_state_hash(from_json) == _state_hash(board), "JSON number and array conversion preserves the state")
	return true


func _test_hint_undo_reset() -> bool:
	var level: PostalLevel = LevelModel.load_default()
	var board: PostalBoard = BoardModel.new(level)
	var first: Dictionary = board.snapshot()
	var first_ports: PackedInt32Array = first["ports"]
	var hinted: int = board.hint()
	_expect(hinted >= 0 and board.can_rotate(hinted), "hint identifies an editable rail")
	_expect(board.ports[hinted] != level.solution_ports[hinted], "hint refers to an incorrectly oriented rail")
	_expect(board.hints == 1 and board.attempts == 0, "hint records only its own counter")
	_expect(board.ports == first_ports, "hint does not rotate or solve the board")
	_expect(board.undo(), "hint action is reversible")
	_expect(_state_hash(board) == JSON.stringify(first), "undo hint restores the complete prior state")
	board.rotate(int(level.solution_commands[0]["index"]))
	board.simulate()
	_expect(board.attempts == 1, "failed dispatch is counted")
	_expect(board.undo(), "rotation can be undone after a dispatch")
	_expect(board.ports == first_ports and board.rotations == 0, "undo restores rails and rotation counter")
	_expect(board.attempts == 1, "undo does not erase the real dispatched attempt")
	board.reset()
	_expect(_state_hash(board) == JSON.stringify(first), "reset starts a fresh level session")
	_expect(not board.undo(), "reset clears old undo history")
	_apply_solution(board, level)
	var hint_count: int = board.hints
	_expect(board.hint() == -1 and board.hints == hint_count, "solved board has no fabricated hint")
	return true


func _test_error_routes() -> bool:
	var direct_grid: Array = _empty_grid()
	direct_grid[4][0] = "EW"
	direct_grid[4][1] = "EW"
	direct_grid[0][5] = "EW"
	direct_grid[0][0] = "EW"
	_expect_fixture(direct_grid, {"A": [0, 5], "B": [4, 0]}, {"A": [0, 0], "B": [4, 1]}, "outside_board")
	var missing_grid: Array = _empty_grid()
	missing_grid[1][0] = "EW"
	missing_grid[1][1] = "NS"
	missing_grid[1][2] = "EW"
	missing_grid[4][0] = "EW"
	missing_grid[4][1] = "EW"
	_expect_fixture(missing_grid, {"A": [1, 0], "B": [4, 0]}, {"A": [1, 2], "B": [4, 1]}, "missing_connection")
	var wrong_grid: Array = _empty_grid()
	for row: int in [1, 4]:
		wrong_grid[row][0] = "EW"
		wrong_grid[row][1] = "EW"
	_expect_fixture(wrong_grid, {"A": [1, 0], "B": [4, 0]}, {"A": [4, 1], "B": [1, 1]}, "wrong_destination")
	var source_grid: Array = _empty_grid()
	source_grid[1][0] = "EW"
	source_grid[1][1] = "EW"
	source_grid[1][3] = "EW"
	source_grid[4][1] = "EW"
	_expect_fixture(source_grid, {"A": [1, 0], "B": [1, 1]}, {"A": [1, 3], "B": [4, 1]}, "unexpected_source")
	var loop_grid: Array = _empty_grid()
	loop_grid[2][2] = "SE"
	loop_grid[2][3] = "SW"
	loop_grid[3][3] = "NW"
	loop_grid[3][2] = "NE"
	loop_grid[0][5] = "EW"
	loop_grid[4][0] = "EW"
	loop_grid[4][1] = "EW"
	_expect_fixture(loop_grid, {"A": [2, 2], "B": [4, 0]}, {"A": [0, 5], "B": [4, 1]}, "loop")
	var invalid_board: PostalBoard = BoardModel.new(LevelModel.new())
	_expect(invalid_board.evaluate().get("reason", "") == "invalid_board", "uninitialized board fails safely")
	return true


func _test_rotation_properties() -> bool:
	var level: PostalLevel = LevelModel.load_default()
	var board: PostalBoard = BoardModel.new(level)
	var editable: PackedInt32Array = PackedInt32Array()
	for index: int in range(36):
		if board.can_rotate(index):
			editable.append(index)
	var rng := RandomNumberGenerator.new()
	rng.seed = 170714
	var roundtrips_ok: bool = true
	for trial: int in range(PROPERTY_TRIALS):
		var index: int = editable[rng.randi_range(0, editable.size() - 1)]
		var before: String = _state_hash(board)
		if not board.rotate(index) or not board.undo() or _state_hash(board) != before:
			roundtrips_ok = false
			break
	_expect(roundtrips_ok, "1000 seeded move/undo trials restore the full state")
	var rotations_ok: bool = true
	for index: int in editable:
		var before_ports: PackedInt32Array = board.ports.duplicate()
		for turn: int in range(4):
			rotations_ok = board.rotate(index) and rotations_ok
		rotations_ok = rotations_ok and board.ports == before_ports
	_expect(rotations_ok, "four quarter-turns restore every editable rail orientation")
	return true


func _expect_fixture(grid: Array, sources: Dictionary, destinations: Dictionary, reason: String) -> void:
	var data: Dictionary = {
		"schema_version": 1, "grid_size": 6, "id": "fixture-" + reason,
		"title": "Automated failure fixture", "chapter": "Test",
		"initial_grid": grid, "solved_grid": grid.duplicate(true),
		"sources": sources, "destinations": destinations,
		"solution_commands": [], "reference_rotations": 0, "optimality_proven": false,
	}
	var errors: PackedStringArray = LevelModel.validate_data(data)
	_expect(errors.is_empty(), "%s fixture passes structural input validation: %s" % [reason, errors])
	var level: PostalLevel = LevelModel.from_dictionary(data)
	if level == null:
		return
	var board: PostalBoard = BoardModel.new(level)
	var before: String = _state_hash(board)
	var result: Dictionary = board.evaluate()
	_expect(not result.get("success", true), "%s fixture fails explicitly" % reason)
	_expect(result.get("reason", "") == reason, "%s has the expected repairable result code" % reason)
	_expect(_state_hash(board) == before, "%s evaluation is pure" % reason)
	_expect(int(result.get("ticks", 999)) <= 72, "%s terminates within the finite board bound" % reason)
	_expect(_count_events(result.get("events", []), "failure") > 0, "%s is communicated as a view event" % reason)


func _apply_solution(board: PostalBoard, level: PostalLevel) -> bool:
	var accepted: bool = true
	for command: Dictionary in level.solution_commands:
		for turn: int in range(int(command["quarter_turns"])):
			accepted = board.rotate(int(command["index"])) and accepted
	return accepted


func _default_data() -> Dictionary:
	var parsed: Variant = JSON.parse_string(FileAccess.get_file_as_string(LEVEL_PATH))
	return parsed as Dictionary if parsed is Dictionary else {}


func _empty_grid() -> Array:
	var grid: Array = []
	for row_index: int in range(6):
		var row: Array[String] = []
		for column_index: int in range(6):
			row.append("")
		grid.append(row)
	return grid


func _count_events(events: Array, kind: String) -> int:
	var count: int = 0
	for event: Dictionary in events:
		if event.get("type", "") == kind:
			count += 1
	return count


func _state_hash(board: PostalBoard) -> String:
	return JSON.stringify(board.snapshot())


func _expect(condition: bool, description: String) -> void:
	if condition:
		_passed += 1
	else:
		_failed += 1
		push_error("SLICE_GAMEPLAY_FAIL %s" % description)
