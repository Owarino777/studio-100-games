class_name LittoralBoardView
extends PostalBoardView
## Same input projection and simulation events, new isolated asset family.

const MODEL_ROOT = "res://assets/littoral-study/models/"
const ART = preload("res://experiments/littoral/littoral_models.gd")
var _pieces: Array[Node3D] = []
var _tile_batches: Array[MultiMeshInstance3D] = []


func _ready() -> void:
	super._ready()
	_camera.keep_aspect = Camera3D.KEEP_WIDTH
	_camera.size = 6.72
	_camera.position = Vector3(0, 10, 6.5)
	_camera.look_at(Vector3(0, 0.08, 0))
	for node: Node in _world.get_children():
		if node is DirectionalLight3D:
			var light := node as DirectionalLight3D
			if light.shadow_enabled:
				light.rotation_degrees = Vector3(-57, -32, 0)
				light.light_energy = 0.52
				light.shadow_opacity = 0.32
				light.shadow_normal_bias = 0.65
				light.shadow_bias = 0.05
			else: light.light_energy = 0.10
		elif node is WorldEnvironment:
			var env: Environment = (node as WorldEnvironment).environment
			env.ambient_light_energy = 0.20
			env.background_color = Color("c6e0e4")
			env.tonemap_mode = Environment.TONE_MAPPER_LINEAR


static func model(id: String) -> Node3D:
	return (load(MODEL_ROOT + id + ".glb") as PackedScene).instantiate() as Node3D


func configure(level: PostalLevel, ports: PackedInt32Array) -> void:
	_level = level
	_ports = ports.duplicate()
	var island: Node3D = ART.island()
	ART.batch_static(island)
	_world.add_child(island)
	_build_tile_batches()
	for index: int in range(36):
		var tile := Node3D.new()
		tile.name = "TilePosition%d" % index
		tile.position = cell_position(index)
		_world.add_child(tile)
		_pieces.append(tile)
		if not level.fixed_indices.has(index) and ports[index] != 0: _rebuild_rail(index)
	for label: String in ["A", "B"]:
		for is_source: bool in [true, false]:
			var index: int = level.source_indices[label] if is_source else level.destination_indices[label]
			var station: Node3D = model(("guichet_" if is_source else "boite_") + label.to_lower())
			station.position = cell_position(index)
			_world.add_child(station)
			if not is_source: _receptions[label] = station
		var parcel: Node3D = model("colis_" + label.to_lower())
		_world.add_child(parcel)
		_parcels[label] = parcel
	for at: Vector3 in [Vector3(-3.07, 0, 2.9), Vector3(3.07, 0, -2.85)]:
		var plant: Node3D = PostalArtFactory.create_flower()
		plant.position = at
		plant.scale = Vector3.ONE * 0.74
		ART.batch_static(plant)
		_world.add_child(plant)
	reset_parcels()
	set_selected(_selected_index)
	_request_frame()


func _build_tile_batches() -> void:
	var source: Node3D = model("tuile")
	for node: Node in source.find_children("*", "MeshInstance3D", true, false):
		var mesh_node := node as MeshInstance3D
		var multimesh := MultiMesh.new()
		multimesh.transform_format = MultiMesh.TRANSFORM_3D
		multimesh.mesh = mesh_node.mesh
		multimesh.instance_count = 36
		for index in 36:
			multimesh.set_instance_transform(index, Transform3D(Basis.IDENTITY, cell_position(index)) * mesh_node.transform)
		var instance := MultiMeshInstance3D.new()
		instance.multimesh = multimesh
		instance.material_override = mesh_node.material_override
		instance.name = "InstancedTiles_" + mesh_node.name
		_world.add_child(instance)
		_tile_batches.append(instance)
	source.free()


func _make_marker(color: Color) -> Node3D:
	var marker: Node3D = ART.BASE.create_selection(color)
	for node: Node in marker.find_children("*", "MeshInstance3D", true, false):
		var mesh := node as MeshInstance3D
		# The inherited marker contract places the root at Y=.25. The reusable
		# factory mesh includes its own .145 offset; cancel it, or brackets float.
		mesh.position.y = -0.145
		mesh.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
		var material := mesh.material_override as StandardMaterial3D
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	return marker


func _rebuild_rail(index: int) -> void:
	if _rails.has(index):
		_world.remove_child(_rails[index])
		_rails[index].queue_free()
	var ports: int = _ports[index]
	var straight: bool = ports == 5 or ports == 10
	var rail: Node3D = model("voie_droite" if straight else "voie_coude")
	var angle: float = 0.0
	if straight:
		angle = PI * 0.5 if ports == 10 else 0.0
	else:
		angle = {3: 0.0, 6: -PI * 0.5, 12: -PI, 9: -PI * 1.5}.get(ports, 0.0)
	# Rotation signs match the existing view and the model's clockwise masks.
	rail.rotation.y = angle
	rail.set_meta("ports", ports)
	rail.position = cell_position(index)
	_world.add_child(rail)
	_rails[index] = rail
	_request_frame()


func get_render_contract() -> Dictionary:
	var triangles: int = 0
	var meshes: int = 0
	for node: Node in _world.find_children("*", "MeshInstance3D", true, false):
		var instance := node as MeshInstance3D
		meshes += 1
		for i in instance.mesh.get_surface_count():
			var arrays: Array = instance.mesh.surface_get_arrays(i)
			var indices: Variant = arrays[Mesh.ARRAY_INDEX]
			triangles += indices.size() / 3 if indices is PackedInt32Array and not indices.is_empty() else (arrays[Mesh.ARRAY_VERTEX] as PackedVector3Array).size() / 3
	for instance: MultiMeshInstance3D in _tile_batches:
		meshes += 1
		for i in instance.multimesh.mesh.get_surface_count():
			var arrays: Array = instance.multimesh.mesh.surface_get_arrays(i)
			var indices: Variant = arrays[Mesh.ARRAY_INDEX]
			var per_instance: int = indices.size() / 3 if indices is PackedInt32Array and not indices.is_empty() else (arrays[Mesh.ARRAY_VERTEX] as PackedVector3Array).size() / 3
			triangles += per_instance * instance.multimesh.instance_count
	return {"mesh_nodes_including_multimesh": meshes, "tile_instances": 36, "submitted_triangles_all_instances": triangles, "camera_position": _camera.position, "camera_width_units": _camera.size, "renderer": "Compatibility", "source": "traversal of actual instantiated meshes; no GPU/thermal inference"}
