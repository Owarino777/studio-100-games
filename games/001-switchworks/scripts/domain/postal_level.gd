class_name PostalLevel
extends RefCounted
## Validated data for the experimental two-route level. No scene or UI dependency.

const DEFAULT_PATH: String = "res://data/archipel_double_flux.json"
const GRID_SIZE: int = 6
const CELL_COUNT: int = GRID_SIZE * GRID_SIZE
const NORTH: int = 1
const EAST: int = 2
const SOUTH: int = 4
const WEST: int = 8
const LABELS: Array[String] = ["A", "B"]

var id: String = ""
var title: String = ""
var chapter: String = ""
var reference_rotations: int = 0
var is_valid: bool = false

var initial_ports: PackedInt32Array:
	get:
		return _initial_ports.duplicate()
var solution_ports: PackedInt32Array:
	get:
		return _solution_ports.duplicate()
var source_indices: Dictionary[String, int]:
	get:
		return _source_indices.duplicate()
var destination_indices: Dictionary[String, int]:
	get:
		return _destination_indices.duplicate()
var fixed_indices: PackedInt32Array:
	get:
		return _fixed_indices.duplicate()
var solution_commands: Array[Dictionary]:
	get:
		var result: Array[Dictionary] = []
		for command: Dictionary in _solution_commands:
			result.append(command.duplicate(true))
		return result

var _initial_ports: PackedInt32Array = PackedInt32Array()
var _solution_ports: PackedInt32Array = PackedInt32Array()
var _source_indices: Dictionary[String, int] = {}
var _destination_indices: Dictionary[String, int] = {}
var _fixed_indices: PackedInt32Array = PackedInt32Array()
var _solution_commands: Array[Dictionary] = []


static func load_default() -> PostalLevel:
	var file: FileAccess = FileAccess.open(DEFAULT_PATH, FileAccess.READ)
	if file == null:
		return null
	var parser: JSON = JSON.new()
	if parser.parse(file.get_as_text()) != OK or not parser.data is Dictionary:
		return null
	return from_dictionary(parser.data as Dictionary)


static func from_dictionary(data: Dictionary) -> PostalLevel:
	if not validate_data(data).is_empty():
		return null
	var level: PostalLevel = PostalLevel.new()
	level.id = str(data["id"])
	level.title = str(data["title"])
	level.chapter = str(data["chapter"])
	level.reference_rotations = int(data["reference_rotations"])
	level._initial_ports = _decode_grid(data["initial_grid"] as Array)
	level._solution_ports = _decode_grid(data["solved_grid"] as Array)
	for label: String in LABELS:
		level._source_indices[label] = _coordinate_index(data["sources"][label])
		level._destination_indices[label] = _coordinate_index(data["destinations"][label])
		level._fixed_indices.append(level._source_indices[label])
		level._fixed_indices.append(level._destination_indices[label])
	for raw_command: Dictionary in data["solution_commands"]:
		level._solution_commands.append({
			"index": int(raw_command["index"]),
			"quarter_turns": int(raw_command["quarter_turns"]),
		})
	level.is_valid = true
	return level


static func validate_data(data: Dictionary) -> PackedStringArray:
	var errors: PackedStringArray = PackedStringArray()
	if not _is_integer_between(data.get("schema_version"), 1, 1):
		errors.append("schema_version must be 1")
	if not _is_integer_between(data.get("grid_size"), GRID_SIZE, GRID_SIZE):
		errors.append("grid_size must be 6")
	for key: String in ["id", "title", "chapter"]:
		if not data.get(key) is String or str(data.get(key)).is_empty() or str(data.get(key)).length() > 100:
			errors.append("%s must be a non-empty string of at most 100 characters" % key)
	_validate_grid(data.get("initial_grid"), "initial_grid", errors)
	_validate_grid(data.get("solved_grid"), "solved_grid", errors)
	for key: String in ["sources", "destinations"]:
		if not data.get(key) is Dictionary:
			errors.append("%s must contain A and B coordinates" % key)
			continue
		var stations: Dictionary = data[key]
		if stations.size() != 2 or not stations.has("A") or not stations.has("B"):
			errors.append("%s must contain exactly A and B" % key)
		for label: String in LABELS:
			if _coordinate_index(stations.get(label)) < 0:
				errors.append("%s.%s must be a zero-based row/column within 6x6" % [key, label])
	if not data.get("solution_commands") is Array or (data["solution_commands"] as Array).size() > 72:
		errors.append("solution_commands must be an array with at most 72 commands")
	if not _is_integer_between(data.get("reference_rotations"), 0, 216):
		errors.append("reference_rotations must be an integer from 0 to 216")
	if data.get("optimality_proven", false) != false:
		errors.append("this experimental witness does not prove optimality")
	if not errors.is_empty():
		return errors
	var initial: PackedInt32Array = _decode_grid(data["initial_grid"] as Array)
	var solution: PackedInt32Array = _decode_grid(data["solved_grid"] as Array)
	var fixed: PackedInt32Array = PackedInt32Array()
	for label: String in LABELS:
		var source: int = _coordinate_index(data["sources"][label])
		var destination: int = _coordinate_index(data["destinations"][label])
		if fixed.has(source) or fixed.has(destination) or source == destination:
			errors.append("four station cells must be distinct")
		fixed.append(source)
		fixed.append(destination)
		if (initial[source] & EAST) == 0:
			errors.append("source %s must expose its east departure port" % label)
	for index: int in range(CELL_COUNT):
		if _shape(initial[index]) != _shape(solution[index]):
			errors.append("initial/solved tile shapes differ at cell %d" % index)
		if fixed.has(index) and (initial[index] == 0 or initial[index] != solution[index]):
			errors.append("fixed station ports differ at cell %d" % index)
	var witness_turns: int = 0
	for raw_command: Variant in data["solution_commands"]:
		if not raw_command is Dictionary:
			errors.append("solution command must be an object")
			continue
		var command: Dictionary = raw_command
		if not _is_integer_between(command.get("index"), 0, CELL_COUNT - 1) or not _is_integer_between(command.get("quarter_turns"), 1, 3):
			errors.append("solution command index/quarter_turns invalid")
			continue
		var index: int = int(command["index"])
		if fixed.has(index) or initial[index] == 0:
			errors.append("solution command cannot rotate a station or empty cell")
		witness_turns += int(command["quarter_turns"])
	if witness_turns != int(data["reference_rotations"]):
		errors.append("reference_rotations differs from witness command count")
	return errors


static func rotate_mask_clockwise(mask: int) -> int:
	return ((mask << 1) & 15) | ((mask >> 3) & 1)


static func _is_integer_between(value: Variant, minimum: int, maximum: int) -> bool:
	if typeof(value) != TYPE_INT and typeof(value) != TYPE_FLOAT:
		return false
	var number: float = float(value)
	return number >= minimum and number <= maximum and number == floorf(number)


static func _coordinate_index(raw: Variant) -> int:
	if not raw is Array or (raw as Array).size() != 2:
		return -1
	var coordinate: Array = raw
	if not _is_integer_between(coordinate[0], 0, GRID_SIZE - 1) or not _is_integer_between(coordinate[1], 0, GRID_SIZE - 1):
		return -1
	return int(coordinate[0]) * GRID_SIZE + int(coordinate[1])


static func _validate_grid(raw: Variant, name: String, errors: PackedStringArray) -> void:
	if not raw is Array or (raw as Array).size() != GRID_SIZE:
		errors.append("%s must have six rows" % name)
		return
	for row: Variant in raw:
		if not row is Array or (row as Array).size() != GRID_SIZE:
			errors.append("%s rows must have six cells" % name)
			continue
		for value: Variant in row:
			if not value is String or mask_from_code(str(value)) < 0:
				errors.append("%s contains an invalid two-port tile" % name)


static func _decode_grid(grid: Array) -> PackedInt32Array:
	var result: PackedInt32Array = PackedInt32Array()
	for row: Array in grid:
		for code: String in row:
			result.append(mask_from_code(code))
	return result


static func mask_from_code(code: String) -> int:
	match code:
		"": return 0
		"NS", "SN": return NORTH | SOUTH
		"EW", "WE": return EAST | WEST
		"NE", "EN": return NORTH | EAST
		"NW", "WN": return NORTH | WEST
		"SE", "ES": return SOUTH | EAST
		"SW", "WS": return SOUTH | WEST
		_: return -1


static func _shape(mask: int) -> int:
	if mask == 0:
		return 0
	return 1 if mask == (NORTH | SOUTH) or mask == (EAST | WEST) else 2
