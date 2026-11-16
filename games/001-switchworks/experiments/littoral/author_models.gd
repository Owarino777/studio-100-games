extends SceneTree
## Deterministic native authoring. --reuse-sources exports hand-edited TSCN unchanged.

const ART = preload("res://experiments/littoral/littoral_models.gd")
const OUTPUT = "res://assets/littoral-study/"
var failures: int = 0
var inventory: Array[Dictionary] = []


func _initialize() -> void:
	call_deferred("run")


func run() -> void:
	DirAccess.make_dir_recursive_absolute(OUTPUT + "sources")
	DirAccess.make_dir_recursive_absolute(OUTPUT + "models")
	var reuse: bool = OS.get_cmdline_user_args().has("--reuse-sources")
	var names: Array[String] = ["guichet_a", "guichet_b", "boite_a", "boite_b", "voie_droite", "voie_coude", "tuile", "colis_a", "colis_b"]
	for id: String in names:
		var model: Node3D
		var source_path: String = OUTPUT + "sources/" + id + ".tscn"
		if reuse:
			model = load(source_path).instantiate() as Node3D
		else:
			match id:
				"guichet_a": model = ART.station("A", true)
				"guichet_b": model = ART.station("B", true)
				"boite_a": model = ART.station("A", false)
				"boite_b": model = ART.station("B", false)
				"voie_droite": model = ART.rail(true)
				"voie_coude": model = ART.rail(false)
				"tuile": model = ART.tile()
				"colis_a": model = ART.parcel("A")
				_: model = ART.parcel("B")
			ART.normalize_geometry(model)
			set_owners(model, model)
			var packed := PackedScene.new()
			check(packed.pack(model) == OK, id + " pack source")
			check(ResourceSaver.save(packed, source_path) == OK, id + " save source")
		root.add_child(model)
		batch(model)
		var document := GLTFDocument.new()
		document.root_node_mode = GLTFDocument.ROOT_NODE_MODE_SINGLE_ROOT
		var state := GLTFState.new()
		var path: String = OUTPUT + "models/" + id + ".glb"
		check(document.append_from_scene(model, state) == OK, id + " append scene")
		check(document.write_to_filesystem(state, path) == OK, id + " GLB export")
		# Read interchange bytes independently, rather than trusting export exit 0.
		var loaded := GLTFState.new()
		check(document.append_from_file(path, loaded) == OK, id + " GLB re-read")
		var decoded: Node = document.generate_scene(loaded)
		check(decoded != null, id + " scene from GLB")
		if decoded != null: decoded.free()
		inventory.append({"id": id, "source": source_path, "export": path, "bytes": FileAccess.get_file_as_bytes(path).size(), "sha256": FileAccess.get_sha256(path)})
		model.free()
	var file := FileAccess.open(OUTPUT + "model-exports.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(inventory, "\t") + "\n")
	file.close()
	print("LITTORAL_AUTHOR models=%d failures=%d" % [inventory.size(), failures])
	quit(1 if failures else 0)


func set_owners(node: Node, owner_root: Node) -> void:
	for child: Node in node.get_children():
		child.owner = owner_root
		set_owners(child, owner_root)


func batch(node: Node3D) -> void:
	# Preserve articulated groups and exact port nodes; batch static meshes by material.
	var groups: Dictionary = {}
	for child: Node in node.get_children():
		if child is Node3D and child.name in ["ReceptionLid", "ReceiptSeal"]:
			batch(child)
		else:
			gather(child, Transform3D.IDENTITY, groups)
			if child is MeshInstance3D or not child.name.begins_with("Port"): child.queue_free()
	for material: Material in groups:
		var tool: SurfaceTool = groups[material]
		var mesh: ArrayMesh = tool.commit()
		var instance := MeshInstance3D.new()
		instance.name = "Batch_" + material.resource_name
		instance.mesh = mesh
		instance.material_override = material
		node.add_child(instance)
	# Export must not see the still-queued editable geometry.
	for child: Node in node.get_children():
		if child.is_queued_for_deletion():
			node.remove_child(child)
			child.free()


func gather(node: Node, transform: Transform3D, groups: Dictionary) -> void:
	var next: Transform3D = transform
	if node is Node3D: next = transform * (node as Node3D).transform
	if node is MeshInstance3D:
		var instance := node as MeshInstance3D
		for surface: int in instance.mesh.get_surface_count():
			var material: Material = instance.material_override if instance.material_override != null else instance.mesh.surface_get_material(surface)
			if not groups.has(material):
				var tool := SurfaceTool.new()
				tool.begin(Mesh.PRIMITIVE_TRIANGLES)
				groups[material] = tool
			groups[material].append_from(instance.mesh, surface, next)
	for child: Node in node.get_children(): gather(child, next, groups)


func check(value: bool, label: String) -> void:
	if not value:
		failures += 1
		push_error(label)
