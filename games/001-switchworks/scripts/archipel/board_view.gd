class_name PostalBoardView
extends TextureRect
## Real orthographic 3D objects. The view never decides whether a delivery succeeds.

signal cell_pressed(index: int)

const INK: Color = Color("203c56")
const CORAL: Color = Color("d57757")
const BLUE: Color = Color("508ebc")
const STEP_SECONDS: float = 0.32

var _viewport: SubViewport
var _world: Node3D
var _camera: Camera3D
var _rails: Dictionary[int, Node3D] = {}
var _parcels: Dictionary[String, Node3D] = {}
var _receptions: Dictionary[String, Node3D] = {}
var _lid_tweens: Dictionary[String, Tween] = {}
var _level: PostalLevel
var _ports: PackedInt32Array = PackedInt32Array()
var _selection: Node3D
var _invalid: Node3D
var _selected_index: int = 8
var _animation: Dictionary = {}
var _render_scale: Vector2 = Vector2.ONE
var _rotation_tween: Tween
var _arrival_tweens: Array[Tween] = []
var _simulating: bool = false
var _visuals_paused: bool = false


func _ready() -> void:
	name = "PostalBoardView"
	expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	stretch_mode = TextureRect.STRETCH_SCALE
	mouse_filter = Control.MOUSE_FILTER_STOP
	focus_mode = Control.FOCUS_ALL
	tooltip_text = "Touchez une voie pour la tourner. Clavier : flèches puis Entrée."
	_viewport = SubViewport.new()
	_viewport.name = "NativeBoardViewport"
	_viewport.size = Vector2i(640, 640)
	_viewport.transparent_bg = true
	_viewport.own_world_3d = true
	_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_viewport.msaa_3d = Viewport.MSAA_4X
	add_child(_viewport)
	texture = _viewport.get_texture()
	_world = Node3D.new()
	_world.name = "ArchipelWorld"
	_viewport.add_child(_world)
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("b7d8e3")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("dceaf0")
	environment.ambient_light_energy = 0.32
	environment.tonemap_mode = Environment.TONE_MAPPER_LINEAR
	# Static, low-resolution reflections give the glazed edges a material response.
	# This sky is not the visible background and does not add noise to the puzzle.
	var reflection_material := ProceduralSkyMaterial.new()
	reflection_material.sky_top_color = Color("8faebc")
	reflection_material.sky_horizon_color = Color("eee7d6")
	reflection_material.ground_horizon_color = Color("d1d9cc")
	reflection_material.ground_bottom_color = Color("687d7b")
	reflection_material.energy_multiplier = 0.65
	var reflection_sky := Sky.new()
	reflection_sky.radiance_size = Sky.RADIANCE_SIZE_128
	reflection_sky.process_mode = Sky.PROCESS_MODE_QUALITY
	reflection_sky.sky_material = reflection_material
	environment.sky = reflection_sky
	environment.reflected_light_source = Environment.REFLECTION_SOURCE_SKY
	var world_environment := WorldEnvironment.new()
	world_environment.environment = environment
	_world.add_child(world_environment)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-68, -28, 0)
	sun.light_color = Color("fffaf0")
	sun.light_energy = 0.56
	sun.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_ONLY
	sun.shadow_enabled = true
	# A short, low-opacity orthogonal shadow fits this six-cell miniature.
	# Compatibility does not provide Forward+'s physical penumbra; inspect native pixels.
	sun.directional_shadow_mode = DirectionalLight3D.SHADOW_ORTHOGONAL
	sun.directional_shadow_max_distance = 16.0
	sun.shadow_opacity = 0.24
	sun.shadow_blur = 2.0
	sun.shadow_normal_bias = 0.4
	_world.add_child(sun)
	var fill := DirectionalLight3D.new()
	fill.rotation_degrees = Vector3(-40, 140, 0)
	fill.light_color = Color("dbeaf3")
	fill.light_energy = 0.14
	fill.sky_mode = DirectionalLight3D.SKY_MODE_LIGHT_ONLY
	_world.add_child(fill)
	_camera = Camera3D.new()
	_camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	_camera.size = 6.85
	_camera.near = 0.05
	_camera.far = 30.0
	_world.add_child(_camera)
	_camera.position = Vector3(0, 10, 4.0)
	_camera.look_at(Vector3(0, -0.02, 0))
	_camera.current = true
	_selection = _make_marker(INK)
	_invalid = _make_marker(CORAL)
	_world.add_child(_selection)
	_world.add_child(_invalid)
	_selection.visible = false
	_invalid.visible = false
	resized.connect(_resize_render_target)
	gui_input.connect(_on_gui_input)
	call_deferred("_resize_render_target")
	call_deferred("_prime_render_target")


func configure(level: PostalLevel, ports: PackedInt32Array) -> void:
	_level = level
	_ports = ports.duplicate()
	var island: Node3D = PostalArtFactory.create_island()
	_world.add_child(island)
	for index: int in range(36):
		var tile: Node3D = PostalArtFactory.create_tile()
		tile.position = cell_position(index)
		_world.add_child(tile)
		if not level.fixed_indices.has(index) and ports[index] != 0:
			_rebuild_rail(index)
	for label: String in ["A", "B"]:
		var color: Color = BLUE if label == "A" else CORAL
		for is_source: bool in [true, false]:
			var index: int = level.source_indices[label] if is_source else level.destination_indices[label]
			var station: Node3D = PostalArtFactory.create_station(label, is_source, color)
			station.position = cell_position(index)
			_world.add_child(station)
			if not is_source:
				_receptions[label] = station
		var parcel: Node3D = PostalArtFactory.create_parcel(label, color)
		_world.add_child(parcel)
		_parcels[label] = parcel
	for point: Vector3 in [Vector3(-3.0, 0.10, 3.0), Vector3(3.0, 0.10, 3.0)]:
		var flower: Node3D = PostalArtFactory.create_flower()
		flower.position = point
		flower.scale = Vector3.ONE * 1.05
		_world.add_child(flower)
	reset_parcels()
	set_selected(_selected_index)
	_request_frame()


func sync_ports(ports: PackedInt32Array, animated_index: int = -1) -> void:
	if _rotation_tween != null and _rotation_tween.is_valid():
		_rotation_tween.kill()
	_ports = ports.duplicate()
	for index: int in _rails:
		if index == animated_index:
			var rail: Node3D = _rails[index]
			_rotation_tween = create_tween()
			_rotation_tween.tween_property(rail, "rotation:y", rail.rotation.y - PI * 0.5, 0.16).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			_rotation_tween.tween_callback(_rebuild_rail.bind(index))
			_rotation_tween.finished.connect(_transition_finished)
		else:
			_rebuild_rail(index)
	_request_frame()


func set_animation_paused(paused: bool) -> void:
	_visuals_paused = paused
	if _rotation_tween != null and _rotation_tween.is_valid():
		if paused: _rotation_tween.pause()
		else: _rotation_tween.play()
	for tween: Tween in _arrival_tweens:
		if tween.is_valid():
			if paused: tween.pause()
			else: tween.play()
	_request_frame()


func finish_transitions() -> void:
	if _rotation_tween != null and _rotation_tween.is_valid(): _rotation_tween.kill()
	for tween: Tween in _arrival_tweens:
		if tween.is_valid(): tween.kill()
	_arrival_tweens.clear()
	_lid_tweens.clear()
	for label: String in _parcels:
		_parcels[label].scale = Vector3.ONE
		if _animation.has(label) and bool(_animation[label].get("arrived", false)):
			_complete_receipt(label)
		else:
			_set_lid_angle(label, 0.0)
	sync_ports(_ports)


func _rebuild_rail(index: int) -> void:
	if _rails.has(index):
		_rails[index].queue_free()
	# This level presents two independent upper/lower postal routes. Colour supports
	# the address letters and shapes; it is never used by the rules engine.
	# Match the material used by the fixed station continuation at each port.
	var rail_color: Color = (BLUE if index < 18 else CORAL).darkened(0.12)
	var rail: Node3D = PostalArtFactory.create_rail(_ports[index], rail_color)
	rail.position = cell_position(index)
	_world.add_child(rail)
	_rails[index] = rail
	_request_frame()


static func cell_position(index: int) -> Vector3:
	return Vector3(float(index % 6) - 2.5, 0, float(index / 6) - 2.5)


func set_selected(index: int) -> void:
	_selected_index = clampi(index, 0, 35)
	_selection.position = cell_position(_selected_index) + Vector3(0, 0.25, 0)
	_selection.visible = true
	_request_frame()


func show_invalid(index: int) -> void:
	_invalid.visible = index >= 0 and index < 36
	if _invalid.visible:
		_invalid.position = cell_position(index) + Vector3(0, 0.265, 0)
	_request_frame()


func reset_parcels() -> void:
	_simulating = false
	for tween: Tween in _arrival_tweens:
		if tween.is_valid(): tween.kill()
	_arrival_tweens.clear()
	_lid_tweens.clear()
	_animation.clear()
	if _level == null:
		return
	for label: String in _parcels:
		_parcels[label].position = cell_position(_level.source_indices[label]) + Vector3(0.30, 0.23, 0)
		_parcels[label].scale = Vector3.ONE
		_parcels[label].show()
		_set_lid_angle(label, 0.0)
		var seal: Node3D = _reception_part(label, "ReceiptSeal")
		if seal != null:
			seal.hide()
			seal.scale = Vector3.ONE
	_request_frame()


func prepare_simulation(result: Dictionary) -> void:
	reset_parcels()
	_simulating = true
	_selection.hide()
	for label: String in ["A", "B"]:
		var path: PackedInt32Array = result["paths"][label]
		var points: PackedVector3Array = _route_points(path, label)
		var lengths := PackedFloat32Array([0.0])
		for i: int in range(1, points.size()):
			lengths.append(lengths[-1] + points[i - 1].distance_to(points[i]))
		_animation[label] = {
			"points": points, "lengths": lengths,
			"duration": maxf(1.0, float(result["traces"][label]["tick"])) * STEP_SECONDS,
			"success": bool(result["traces"][label]["success"]),
			"arrived": false,
			"lid_opening": false,
		}
	_request_frame()


func advance_simulation(elapsed: float, instantly: bool = false) -> Dictionary:
	var finished: bool = true
	var deliveries: int = 0
	for label: String in _animation:
		var animation: Dictionary = _animation[label]
		var progress: float = 1.0 if instantly else clampf(elapsed / float(animation["duration"]), 0.0, 1.0)
		if progress >= 0.84 and bool(animation["success"]) and not instantly and not bool(animation["lid_opening"]):
			animation["lid_opening"] = true
			_open_reception(label)
		finished = finished and progress >= 1.0
		if progress >= 1.0 and bool(animation["success"]):
			deliveries += 1
		var lengths: PackedFloat32Array = animation["lengths"]
		var points: PackedVector3Array = animation["points"]
		var distance: float = progress * lengths[-1]
		var position: Vector3 = points[-1]
		for i: int in range(1, points.size()):
			if distance <= lengths[i]:
				var interval: float = maxf(0.0001, lengths[i] - lengths[i - 1])
				position = points[i - 1].lerp(points[i], (distance - lengths[i - 1]) / interval)
				break
		if not bool(animation["arrived"]):
			_parcels[label].position = position
		if progress >= 1.0 and bool(animation["success"]) and not bool(animation["arrived"]):
			animation["arrived"] = true
			_receive_parcel(label, instantly)
	return {"finished": finished, "deliveries": deliveries}


func end_simulation() -> void:
	_simulating = false
	_request_frame()


func _reception_part(label: String, part: String) -> Node3D:
	if not _receptions.has(label): return null
	return _receptions[label].get_node_or_null(NodePath(part)) as Node3D


func _set_lid_angle(label: String, angle: float) -> void:
	var lid: Node3D = _reception_part(label, "ReceptionLid")
	if lid != null: lid.rotation.z = angle


func _open_reception(label: String) -> void:
	var lid: Node3D = _reception_part(label, "ReceptionLid")
	if lid == null: return
	var tween := create_tween()
	tween.tween_property(lid, "rotation:z", 0.75, 0.14).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.finished.connect(_transition_finished)
	_lid_tweens[label] = tween
	_arrival_tweens.append(tween)
	print("SLICE_RECEPTION_OPEN address=%s" % label)


func _receive_parcel(label: String, instantly: bool) -> void:
	if _lid_tweens.has(label) and _lid_tweens[label].is_valid(): _lid_tweens[label].kill()
	if instantly:
		_complete_receipt(label)
		return
	var parcel: Node3D = _parcels[label]
	var lid: Node3D = _reception_part(label, "ReceptionLid")
	var seal: Node3D = _reception_part(label, "ReceiptSeal")
	# Only presentation continues after the logical delivery: replay stays immediately available.
	_set_lid_angle(label, 0.75)
	var arrival := create_tween()
	arrival.set_parallel(true)
	arrival.tween_property(parcel, "position", cell_position(_level.destination_indices[label]) + Vector3(0.06, 0.255, 0), 0.24).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	if lid != null:
		arrival.tween_property(lid, "rotation:z", 0.0, 0.18).set_delay(0.14).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	if seal != null:
		seal.scale = Vector3.ONE * 0.82
		arrival.tween_callback(seal.show).set_delay(0.20)
		arrival.tween_property(seal, "scale", Vector3.ONE, 0.18).set_delay(0.20).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	arrival.tween_callback(parcel.hide).set_delay(0.24)
	arrival.chain().tween_callback(_complete_receipt.bind(label))
	arrival.finished.connect(_transition_finished)
	_arrival_tweens.append(arrival)
	_request_frame()


func _complete_receipt(label: String) -> void:
	_set_lid_angle(label, 0.0)
	var seal: Node3D = _reception_part(label, "ReceiptSeal")
	if seal != null:
		seal.show()
		seal.scale = Vector3.ONE
	if _parcels.has(label):
		_parcels[label].hide()
		_parcels[label].scale = Vector3.ONE
	_request_frame()
	print("SLICE_RECEIVED address=%s" % label)


func get_reception_state(label: String) -> Dictionary:
	var seal: Node3D = _reception_part(label, "ReceiptSeal")
	var lid: Node3D = _reception_part(label, "ReceptionLid")
	var parcel: Node3D = _parcels.get(label) as Node3D
	return {"seal_visible": seal != null and seal.visible,
		"lid_rotation": lid.rotation if lid != null else Vector3.ZERO,
		"parcel_scale": parcel.scale if parcel != null else Vector3.ONE,
		"parcel_visible": parcel != null and parcel.visible,
		"received": _animation.has(label) and bool(_animation[label].get("arrived", false))}


func _route_points(path: PackedInt32Array, label: String) -> PackedVector3Array:
	var points := PackedVector3Array()
	var height := Vector3(0, 0.23, 0)
	points.append(cell_position(path[0]) + Vector3(0.30, 0.23, 0))
	points.append(cell_position(path[0]) + Vector3(0.5, 0.23, 0))
	for i: int in range(1, path.size()):
		var center: Vector3 = cell_position(path[i]) + height
		var entry: Vector3 = (cell_position(path[i - 1]) - cell_position(path[i])).normalized()
		if path[i] == _level.destination_indices[label]:
			points.append(center + Vector3(-0.30, 0, 0))
			continue
		var exit: Vector3
		if i + 1 < path.size():
			exit = (cell_position(path[i + 1]) - cell_position(path[i])).normalized()
		else:
			var entry_mask: int = _direction_mask(entry)
			exit = _mask_direction(_ports[path[i]] & ~entry_mask)
		if entry.dot(exit) < -0.9:
			points.append(center + exit * 0.5)
		else:
			var corner: Vector3 = center + (entry + exit) * 0.5
			var start: Vector3 = -exit * 0.5
			var end: Vector3 = -entry * 0.5
			for step: int in range(1, 13):
				points.append(corner + start.slerp(end, float(step) / 12.0))
	return points


static func _direction_mask(direction: Vector3) -> int:
	if direction.x > 0.5: return 2
	if direction.x < -0.5: return 8
	if direction.z > 0.5: return 4
	return 1


static func _mask_direction(mask: int) -> Vector3:
	match mask:
		1: return Vector3.FORWARD
		2: return Vector3.RIGHT
		4: return Vector3.BACK
		_: return Vector3.LEFT


func index_to_canvas_center(index: int) -> Vector2:
	var pixel: Vector2 = _camera.unproject_position(cell_position(index) + Vector3(0, 0.13, 0))
	return global_position + pixel / Vector2(_viewport.size) * size


func cell_at_canvas_point(point: Vector2) -> int:
	if size.x <= 0 or size.y <= 0:
		return -1
	var pixel: Vector2 = point / size * Vector2(_viewport.size)
	var origin: Vector3 = _camera.project_ray_origin(pixel)
	var direction: Vector3 = _camera.project_ray_normal(pixel)
	if absf(direction.y) < 0.0001:
		return -1
	var hit: Vector3 = origin + direction * ((0.13 - origin.y) / direction.y)
	var column: int = floori(hit.x + 3.0)
	var row: int = floori(hit.z + 3.0)
	return row * 6 + column if column >= 0 and row >= 0 and column < 6 and row < 6 else -1


func _on_gui_input(event: InputEvent) -> void:
	# Godot's Control pipeline emulates the primary mouse button from a touch.
	# Handling ScreenTouch as well would apply the same rotation twice.
	if event is InputEventMouseButton:
		var mouse := event as InputEventMouseButton
		if mouse.button_index == MOUSE_BUTTON_LEFT and mouse.pressed:
			var index: int = cell_at_canvas_point(mouse.position)
			if index >= 0:
				grab_focus()
				cell_pressed.emit(index)
				accept_event()
	if event is InputEventKey and event.is_pressed() and not event.is_echo():
		var next: int = _selected_index
		if event.is_action_pressed("ui_left"): next = maxi(0, next - 1)
		elif event.is_action_pressed("ui_right"): next = mini(35, next + 1)
		elif event.is_action_pressed("ui_up"): next = maxi(0, next - 6)
		elif event.is_action_pressed("ui_down"): next = mini(35, next + 6)
		elif event.is_action_pressed("ui_accept"):
			cell_pressed.emit(_selected_index)
			accept_event()
			return
		else: return
		set_selected(next)
		accept_event()


func _resize_render_target() -> void:
	if _viewport == null or size.x < 2 or size.y < 2:
		return
	var logical: Vector2 = get_viewport_rect().size
	var ratio: Vector2 = Vector2(get_window().size) / logical if logical.x > 0 and logical.y > 0 else Vector2.ONE
	_render_scale = Vector2.ONE * minf(ratio.x, ratio.y)
	_viewport.size = Vector2i(clampi(roundi(size.x * _render_scale.x), 128, 1600), clampi(roundi(size.y * _render_scale.y), 128, 1600))
	_request_frame()


func _prime_render_target() -> void:
	if DisplayServer.get_name() == "headless": return
	# Let deferred 3D font geometry and the first atlas upload finish before caching.
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	_request_frame()


func invalidate_render() -> void:
	_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	call_deferred("_prime_render_target")


func _transition_finished() -> void:
	# Evaluate running flags after the Tween has finished its signal dispatch.
	call_deferred("_request_frame")


func _request_frame() -> void:
	if _viewport == null: return
	var moving: bool = _simulating
	if _rotation_tween != null and _rotation_tween.is_valid():
		moving = moving or _rotation_tween.is_running()
	for tween: Tween in _arrival_tweens:
		moving = moving or (tween.is_valid() and tween.is_running())
	_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS if moving and not _visuals_paused else SubViewport.UPDATE_ONCE


func _make_marker(color: Color) -> Node3D:
	var marker := Node3D.new()
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	for x: float in [-0.43, 0.43]:
		for z: float in [-0.43, 0.43]:
			for horizontal: bool in [true, false]:
				var mesh := BoxMesh.new()
				mesh.size = Vector3(0.20, 0.025, 0.035) if horizontal else Vector3(0.035, 0.025, 0.20)
				var instance := MeshInstance3D.new()
				instance.mesh = mesh
				instance.material_override = material
				instance.position = Vector3(x - signf(x) * 0.08 if horizontal else x, 0, z if horizontal else z - signf(z) * 0.08)
				marker.add_child(instance)
	return marker
