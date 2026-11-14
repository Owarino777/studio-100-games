extends SceneTree
## Geometry and semantic checks, separate from the gameplay runner.

const ART := preload("res://scripts/visuals/postal_art_factory.gd")
var _passed: int = 0
var _failed: int = 0
var _mesh_count: int = 0
var _triangle_count: int = 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var tile: Node3D = ART.create_tile()
	root.add_child(tile)
	var tile_mesh: Mesh = (tile.get_node("GlazedTile") as MeshInstance3D).mesh
	var tile_bounds: AABB = tile_mesh.get_aabb()
	_expect(is_equal_approx(tile_bounds.end.y, 0.12), "tile top remains at the shared height")
	_expect(tile_bounds.size.x < 1.0 and tile_bounds.size.z < 1.0, "tile leaves a physical seam inside one cell")
	_inspect(tile)
	tile.free()
	for mask: int in [3, 5, 6, 9, 10, 12]:
		var rail: Node3D = ART.create_rail(mask)
		root.add_child(rail)
		_expect(rail.get_child_count() == 2, "rail combines tubing and sleepers into two meshes")
		for child: Node in rail.get_children():
			var instance := child as MeshInstance3D
			var bounds: AABB = instance.global_transform * instance.mesh.get_aabb()
			_expect(bounds.position.x >= -0.53 and bounds.end.x <= 0.53 and bounds.position.z >= -0.53 and bounds.end.z <= 0.53, "rail stays inside cell port tolerance")
		_inspect(rail)
		rail.free()
	for label: String in ["A", "B"]:
		var color: Color = ART.BLUE if label == "A" else ART.CORAL
		for source: bool in [true, false]:
			var station: Node3D = ART.create_station(label, source, color)
			root.add_child(station)
			_expect(station.get_meta("port") == ("E" if source else "W"), "station has an explicit physical role and port")
			_expect(is_zero_approx((station.get_node("StationTrack") as Node3D).position.y), "fixed and rotatable rail ports share the same height")
			_inspect(station)
			station.free()
		var parcel: Node3D = ART.create_parcel(label, color)
		root.add_child(parcel)
		_expect(parcel.get_meta("shape") == ("triangle" if label == "B" else "circle"), "parcel shape matches its address identity")
		_inspect(parcel)
		parcel.free()
	for decoration: Node3D in [ART.create_island(), ART.create_flower(), ART.create_cloud(), ART.create_selection()]:
		root.add_child(decoration)
		_inspect(decoration)
		decoration.free()
	print("ART_FAMILY passed=%d failed=%d mesh_instances=%d custom_triangles=%d" % [_passed, _failed, _mesh_count, _triangle_count])
	quit(1 if _failed > 0 else 0)


func _inspect(node: Node) -> void:
	if node.has_meta("shape"):
		var label: String = str(node.get_meta("address_label", ""))
		_expect(node.get_meta("shape") == ("triangle" if label == "B" else "circle"), "every address sign uses the invariant geometric code")
	if node is MeshInstance3D:
		var instance := node as MeshInstance3D
		_mesh_count += 1
		_expect(instance.mesh != null and instance.material_override != null, "mesh and material exist")
		var bounds: AABB = instance.mesh.get_aabb()
		_expect(bounds.position.is_finite() and bounds.size.is_finite() and bounds.size.length() > 0.0, "mesh bounds are finite and non-empty")
		if instance.mesh is ArrayMesh:
			for surface in instance.mesh.get_surface_count():
				var arrays: Array = instance.mesh.surface_get_arrays(surface)
				var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
				var normals: PackedVector3Array = arrays[Mesh.ARRAY_NORMAL]
				_expect(vertices.size() == normals.size() and vertices.size() % 3 == 0, "custom mesh triangles have explicit normals")
				_triangle_count += vertices.size() / 3
				var finite: bool = true
				for vertex: Vector3 in vertices:
					finite = finite and vertex.is_finite()
				_expect(finite, "all custom vertices are finite")
	for child: Node in node.get_children():
		_inspect(child)


func _expect(condition: bool, description: String) -> void:
	if condition:
		_passed += 1
	else:
		_failed += 1
		push_error("ART_FAIL " + description)
