extends "res://experiments/littoral/author_models.gd"
## Reuse the checked exporter, preserve the earlier study sources and exports.

const W = preload("res://experiments/postal_workshop/workshop_models.gd")
const DEST = "res://assets/postal-workshop/"


func run() -> void:
	DirAccess.make_dir_recursive_absolute(DEST + "sources")
	DirAccess.make_dir_recursive_absolute(DEST + "models")
	var names: Array[String] = ["guichet_a", "guichet_b", "boite_a", "boite_b", "voie_droite", "voie_coude", "tuile", "colis_a", "colis_b", "socle"]
	var reuse: bool = OS.get_cmdline_user_args().has("--reuse-sources")
	for id: String in names:
		var model: Node3D
		var source: String = DEST + "sources/" + id + ".tscn"
		if reuse: model = load(source).instantiate() as Node3D
		else:
			match id:
				"guichet_a": model = W.station("A", true)
				"guichet_b": model = W.station("B", true)
				"boite_a": model = W.station("A", false)
				"boite_b": model = W.station("B", false)
				"voie_droite": model = W.track(true)
				"voie_coude": model = W.track(false)
				"tuile": model = W.tile()
				"colis_a": model = W.parcel("A")
				"colis_b": model = W.parcel("B")
				_: model = W.plinth()
			W.L.normalize_geometry(model)
			set_owners(model, model)
			var packed := PackedScene.new()
			check(packed.pack(model) == OK, id + " source pack")
			check(ResourceSaver.save(packed, source) == OK, id + " source save")
		root.add_child(model)
		batch(model)
		var document := GLTFDocument.new()
		document.root_node_mode = GLTFDocument.ROOT_NODE_MODE_SINGLE_ROOT
		var state := GLTFState.new()
		var file: String = DEST + "models/" + id + ".glb"
		check(document.append_from_scene(model, state) == OK, id + " scene export")
		check(document.write_to_filesystem(state, file) == OK, id + " GLB write")
		var imported := GLTFState.new()
		check(document.append_from_file(file, imported) == OK, id + " GLB read")
		var decoded: Node = document.generate_scene(imported)
		check(decoded != null, id + " scene read")
		if decoded != null: decoded.free()
		inventory.append({"id": id, "source": source, "export": file, "sha256": FileAccess.get_sha256(file)})
		model.free()
	check(ResourceSaver.save(WorkshopTheme.make(), "res://ui/workshop/workshop_theme.tres") == OK, "theme resource")
	var output := FileAccess.open(DEST + "model-exports.json", FileAccess.WRITE)
	output.store_string(JSON.stringify(inventory, "\t") + "\n")
	output.close()
	print("WORKSHOP_AUTHOR models=%d failures=%d" % [inventory.size(), failures])
	quit(1 if failures else 0)
