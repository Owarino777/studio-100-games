class_name PostalBoard
extends RefCounted
## Deterministic puzzle state. Rendering replays the returned events; it cannot alter results.

const DIRECTIONS: Array[int] = [1, 2, 4, 8]
const OFFSETS: Dictionary[int, Vector2i] = {
	1: Vector2i(0, -1), 2: Vector2i(1, 0), 4: Vector2i(0, 1), 8: Vector2i(-1, 0),
}
const OPPOSITE: Dictionary[int, int] = {1: 4, 2: 8, 4: 1, 8: 2}
const EVENT_ORDER: Dictionary[String, int] = {"spawn": 0, "move": 1, "delivered": 2, "failure": 2}

var level: PostalLevel
var rotations: int = 0
var attempts: int = 0
var hints: int = 0
var last_result: Dictionary = {}
var ports: PackedInt32Array:
	get:
		return _ports.duplicate()

var _ports: PackedInt32Array = PackedInt32Array()
var _undo: Array[Dictionary] = []


func _init(loaded_level: PostalLevel = null) -> void:
	level = loaded_level if loaded_level != null else PostalLevel.load_default()
	reset()


func can_rotate(index: int) -> bool:
	return _has_level() and index >= 0 and index < PostalLevel.CELL_COUNT and _ports[index] != 0 and not level.fixed_indices.has(index)


func rotate(index: int) -> bool:
	if not can_rotate(index):
		return false
	_record_edit()
	_ports[index] = PostalLevel.rotate_mask_clockwise(_ports[index])
	rotations += 1
	last_result = {}
	return true


func undo() -> bool:
	if _undo.is_empty():
		return false
	var previous: Dictionary = _undo.pop_back()
	_ports = (previous["ports"] as PackedInt32Array).duplicate()
	rotations = int(previous["rotations"])
	hints = int(previous["hints"])
	last_result = {}
	return true


func can_undo() -> bool:
	return not _undo.is_empty()


func reset() -> void:
	_ports = level.initial_ports if _has_level() else PackedInt32Array()
	rotations = 0
	attempts = 0
	hints = 0
	_undo.clear()
	last_result = {}


func hint() -> int:
	if not _has_level() or bool(evaluate()["success"]):
		return -1
	var reference: PackedInt32Array = level.solution_ports
	for index: int in range(PostalLevel.CELL_COUNT):
		if can_rotate(index) and _ports[index] != reference[index]:
			_record_edit()
			hints += 1
			return index
	return -1


func snapshot() -> Dictionary:
	return {
		"schema_version": 1,
		"level_id": level.id if _has_level() else "",
		"ports": _ports.duplicate(),
		"rotations": rotations,
		"attempts": attempts,
		"hints": hints,
	}


func restore_snapshot(state: Dictionary) -> bool:
	if not _has_level() or not PostalLevel._is_integer_between(state.get("schema_version"), 1, 1) or state.get("level_id") != level.id:
		return false
	for counter: String in ["rotations", "attempts", "hints"]:
		if not PostalLevel._is_integer_between(state.get(counter), 0, 2147483647):
			return false
	var raw: Variant = state.get("ports")
	if not raw is Array and not raw is PackedInt32Array:
		return false
	if raw.size() != PostalLevel.CELL_COUNT:
		return false
	var restored: PackedInt32Array = PackedInt32Array()
	var initial: PackedInt32Array = level.initial_ports
	for index: int in range(PostalLevel.CELL_COUNT):
		if not PostalLevel._is_integer_between(raw[index], 0, 15):
			return false
		var mask: int = int(raw[index])
		if not _legal_mask(mask) or PostalLevel._shape(mask) != PostalLevel._shape(initial[index]):
			return false
		if level.fixed_indices.has(index) and mask != initial[index]:
			return false
		restored.append(mask)
	_ports = restored
	rotations = int(state["rotations"])
	attempts = int(state["attempts"])
	hints = int(state["hints"])
	_undo.clear()
	last_result = {}
	return true


func simulate() -> Dictionary:
	attempts += 1
	last_result = evaluate()
	return last_result.duplicate(true)


func evaluate() -> Dictionary:
	var result: Dictionary = {
		"success": false, "reason": "invalid_board", "failing_cell": -1,
		"paths": {}, "deliveries": 0, "events": [], "ticks": 0,
	}
	if not _has_level() or _ports.size() != PostalLevel.CELL_COUNT:
		return result
	var success: bool = true
	var first_failure_tick: int = PostalLevel.CELL_COUNT * 2 + 1
	var traces: Dictionary = {}
	var paths: Dictionary = {}
	var events: Array[Dictionary] = []
	for label: String in PostalLevel.LABELS:
		var trace: Dictionary = _trace(label)
		traces[label] = trace
		paths[label] = (trace["path"] as PackedInt32Array).duplicate()
		events.append_array(_trace_events(label, trace))
		result["ticks"] = maxi(int(result["ticks"]), int(trace["tick"]))
		if bool(trace["success"]):
			result["deliveries"] = int(result["deliveries"]) + 1
		else:
			success = false
			if int(trace["tick"]) < first_failure_tick:
				first_failure_tick = int(trace["tick"])
				result["reason"] = trace["reason"]
				result["failing_cell"] = trace["failing_cell"]
	events.sort_custom(_event_before)
	result["success"] = success
	result["reason"] = "delivered" if success else result["reason"]
	result["paths"] = paths
	result["events"] = events
	result["traces"] = traces
	return result


func _trace(label: String) -> Dictionary:
	var position: int = level.source_indices[label]
	var direction: int = PostalLevel.EAST
	var path: PackedInt32Array = PackedInt32Array([position])
	var visited: Dictionary[int, bool] = {}
	visited[position * 16 + direction] = true
	for tick: int in range(1, PostalLevel.CELL_COUNT * 2 + 1):
		var offset: Vector2i = OFFSETS[direction]
		var coordinate: Vector2i = Vector2i(position % PostalLevel.GRID_SIZE, position / PostalLevel.GRID_SIZE) + offset
		if coordinate.x < 0 or coordinate.y < 0 or coordinate.x >= PostalLevel.GRID_SIZE or coordinate.y >= PostalLevel.GRID_SIZE:
			return _trace_result(false, "outside_board", position, path, tick)
		var next_cell: int = coordinate.y * PostalLevel.GRID_SIZE + coordinate.x
		var entry: int = OPPOSITE[direction]
		if (_ports[next_cell] & entry) == 0:
			return _trace_result(false, "missing_connection", next_cell, path, tick)
		path.append(next_cell)
		if level.destination_indices.values().has(next_cell):
			return _trace_result(next_cell == level.destination_indices[label], "delivered" if next_cell == level.destination_indices[label] else "wrong_destination", next_cell, path, tick)
		if level.source_indices.values().has(next_cell):
			return _trace_result(false, "loop" if next_cell == level.source_indices[label] else "unexpected_source", next_cell, path, tick)
		var exits: int = _ports[next_cell] & ~entry
		if not DIRECTIONS.has(exits):
			return _trace_result(false, "invalid_board", next_cell, path, tick)
		var visit_key: int = next_cell * 16 + exits
		if visited.has(visit_key):
			return _trace_result(false, "loop", next_cell, path, tick)
		visited[visit_key] = true
		position = next_cell
		direction = exits
	return _trace_result(false, "loop", position, path, PostalLevel.CELL_COUNT * 2)


func _trace_result(success: bool, reason: String, cell: int, path: PackedInt32Array, tick: int) -> Dictionary:
	return {"success": success, "reason": reason, "failing_cell": -1 if success else cell, "path": path, "tick": tick}


func _trace_events(label: String, trace: Dictionary) -> Array[Dictionary]:
	var path: PackedInt32Array = trace["path"]
	var events: Array[Dictionary] = [{"type": "spawn", "cargo": label, "cell": path[0], "tick": 0}]
	for index: int in range(1, path.size()):
		events.append({"type": "move", "cargo": label, "from_cell": path[index - 1], "cell": path[index], "tick": index})
	events.append({
		"type": "delivered" if bool(trace["success"]) else "failure", "cargo": label,
		"cell": path[-1] if bool(trace["success"]) else int(trace["failing_cell"]),
		"reason": trace["reason"], "tick": int(trace["tick"]),
	})
	return events


func _record_edit() -> void:
	_undo.append({"ports": _ports.duplicate(), "rotations": rotations, "hints": hints})


func _has_level() -> bool:
	return level != null and level.is_valid


func _legal_mask(mask: int) -> bool:
	return mask == 0 or mask == 3 or mask == 5 or mask == 6 or mask == 9 or mask == 10 or mask == 12


func _event_before(first: Dictionary, second: Dictionary) -> bool:
	if first["tick"] != second["tick"]:
		return int(first["tick"]) < int(second["tick"])
	if first["cargo"] != second["cargo"]:
		return str(first["cargo"]) < str(second["cargo"])
	return EVENT_ORDER[str(first["type"])] < EVENT_ORDER[str(second["type"])]
