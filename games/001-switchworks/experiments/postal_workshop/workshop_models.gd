class_name WorkshopModels
extends RefCounted
## Original editable construction. One world unit/cell; no reference-image pixels.

const L = preload("res://experiments/littoral/littoral_models.gd")
const P = preload("res://scripts/visuals/postal_art_factory.gd")
const T: WorkshopTokens = preload("res://ui/workshop/tokens.tres")
const PATH = "res://assets/postal-workshop/"
static var _materials: Dictionary[String, StandardMaterial3D] = {}
static var _grain: Texture2D


static func material(id: String, color: Color, rough: float, metal: float = 0.0) -> StandardMaterial3D:
	var key: String = id + color.to_html()
	if _materials.has(key): return _materials[key]
	var m := StandardMaterial3D.new()
	m.resource_name = id
	m.albedo_color = color.darkened(0.23) if color.get_luminance() > 0.55 else color
	m.roughness = rough
	m.metallic = metal
	m.cull_mode = BaseMaterial3D.CULL_DISABLED
	_materials[key] = m
	return m


static func grain() -> Texture2D:
	if _grain != null: return _grain
	var image := Image.create(256, 256, false, Image.FORMAT_RGBA8)
	var random := RandomNumberGenerator.new()
	random.seed = 16112026
	for y in 256:
		for x in 256:
			var v: float = 0.965 + random.randf() * 0.035
			image.set_pixel(x, y, Color(v, v, v, 1))
	DirAccess.make_dir_recursive_absolute(PATH + "materials")
	image.save_png(PATH + "materials/ceramic-grain.png")
	image.generate_mipmaps()
	_grain = ImageTexture.create_from_image(image)
	return _grain


static func part(root: Node3D, name: String, size: Vector3, at: Vector3, m: Material, bevel: float = 0.012) -> MeshInstance3D:
	return L.piece(root, name, size, at, m, bevel)


static func tile() -> Node3D:
	var root := Node3D.new()
	root.name = "SatinCeramicTile"
	part(root, "FineBody", Vector3(0.974, 0.105, 0.974), Vector3.ZERO, material("CeramicBody", Color("bcc5bc"), 0.64), 0.022)
	var glaze: StandardMaterial3D = material("CeramicSatin", Color("f3efe4"), 0.56)
	glaze.albedo_texture = grain()
	glaze.vertex_color_use_as_albedo = true
	part(root, "SatinFace", Vector3(0.952, 0.028, 0.952), Vector3(0, 0.102, 0), glaze, 0.010)
	return root


static func track(straight: bool) -> Node3D:
	var root := Node3D.new()
	root.name = "PrecisionStraight" if straight else "PrecisionElbow"
	for offset: float in [-0.10, 0.10]:
		var path := PackedVector3Array()
		for i in (2 if straight else 25):
			var t: float = float(i) / (1.0 if straight else 24.0)
			var a: float = PI - t * PI * 0.5
			path.append(Vector3(offset, 0.175, lerpf(-0.5, 0.5, t)) if straight else Vector3(0.5 + cos(a) * (0.5 + offset), 0.175, -0.5 + sin(a) * (0.5 + offset)))
		L.tube(root, "PaintedRail", path, 0.029, 0.021, material("PaintedMetal", T.primary, 0.32, 0.12))
		for j in path.size(): path[j].y += 0.018
		L.tube(root, "BrushedTop", path, 0.009, 0.005, material("RailHighlight", Color("8bacae"), 0.36, 0.18))
	for i in 4:
		var f: float = (float(i) + 0.5) / 4.0
		var a: float = PI - f * PI * 0.5
		var at := Vector3(0, 0.131, lerpf(-0.5, 0.5, f)) if straight else Vector3(0.5 + cos(a) * 0.5, 0.131, -0.5 + sin(a) * 0.5)
		var tie: MeshInstance3D = part(root, "QuietSleeper", Vector3(0.30, 0.022, 0.046), at, material("MatteFitting", Color("8b9284"), 0.62, 0.18), 0.005)
		tie.rotation.y = 0 if straight else -a
	# A recessed knurled grip signals a rotatable piece, never a T/Y switch.
	L.cylinder(root, "RotationGrip", 0.065, 0.025, Vector3(-0.31, 0.157, 0.31), material("Grip", Color("b6b7a1"), 0.62, 0.18))
	for z: float in [0.29, 0.32]:
		part(root, "GripGroove", Vector3(0.065, 0.007, 0.008), Vector3(-0.31, 0.173, z), material("PaintedMetal", T.primary, 0.32, 0.12), 0.002)
	for mask: int in ([1, 4] if straight else [1, 2]):
		var port := Node3D.new()
		port.name = "Port%d" % mask
		port.position = Vector3(0, 0.175, -0.5) if mask == 1 else (Vector3(0, 0.175, 0.5) if mask == 4 else Vector3(0.5, 0.175, 0))
		root.add_child(port)
	return root


static func badge(root: Node3D, label: String, at: Vector3, scale_factor: float = 1.0, tilt: float = -30) -> void:
	var group := Node3D.new()
	group.name = "Address" + label
	group.position = at
	group.rotation_degrees.x = tilt
	group.scale = Vector3.ONE * scale_factor
	root.add_child(group)
	var color: Color = T.address_a if label == "A" else T.address_b
	var plaque: MeshInstance3D = part(group, "LetterPlate", Vector3(0.31, 0.018, 0.29), Vector3.ZERO, material("CeramicLabel", T.surface, 0.5), 0.004)
	plaque.rotation_degrees.x = 90
	var shape: Mesh
	if label == "A":
		var cylinder := CylinderMesh.new()
		cylinder.top_radius = 0.126
		cylinder.bottom_radius = 0.126
		cylinder.height = 0.006
		cylinder.radial_segments = 24
		shape = cylinder
	else: shape = P._triangle_mesh(0.27, 0.265, 0.006)
	var symbol: MeshInstance3D = P._add_mesh(group, shape, material("Address" + label, color, 0.5), Vector3(0, 0, 0.024))
	symbol.rotation_degrees.x = 90
	L.text(group, label, Vector3(0, -0.003, 0.036), 0.26, T.surface, 0)
	(group.get_child(group.get_child_count() - 1) as MeshInstance3D).material_override = material("LetterIvory", T.surface, 0.5)


static func station(label: String, source: bool) -> Node3D:
	var root := Node3D.new()
	root.name = ("Dispatch" if source else "Intake") + label
	root.set_meta("role", "dispatch" if source else "reception")
	root.set_meta("address_label", label)
	var ivory: StandardMaterial3D = material("CeramicSatin", Color("f3efe4"), 0.56)
	var fitting: StandardMaterial3D = material("MatteFitting", Color("8b9284"), 0.62, 0.18)
	var paint: StandardMaterial3D = material("PaintedMetal", T.primary, 0.32, 0.12)
	var structure: StandardMaterial3D = material("StationPaint", T.primary, 0.38, 0.08)
	var timber: StandardMaterial3D = material("WarmKraft", Color("c3a77e"), 0.90)
	part(root, "FlushStationFoot", Vector3(0.86, 0.035, 0.79), Vector3(0, 0.131, 0), ivory)
	for z: float in [-0.10, 0.10]:
		L.tube(root, "PortRail", PackedVector3Array([Vector3(0.04 if source else -0.5, 0.175, z), Vector3(0.5 if source else 0.08, 0.175, z)]), 0.029, 0.021, paint)
	var port := Node3D.new()
	port.name = "Port2" if source else "Port8"
	port.position = Vector3(0.5 if source else -0.5, 0.175, 0)
	root.add_child(port)
	if source:
		part(root, "BackSpine", Vector3(0.54, 0.45, 0.065), Vector3(-0.15, 0.166, -0.25), ivory)
		part(root, "WestCabinet", Vector3(0.10, 0.43, 0.49), Vector3(-0.385, 0.166, 0), ivory)
		part(root, "Counter", Vector3(0.51, 0.055, 0.11), Vector3(-0.15, 0.30, 0.27), timber)
		for x: float in [-0.39, 0.10]:
			part(root, "OpenBayPost", Vector3(0.045, 0.48, 0.045), Vector3(x, 0.166, 0.29), structure, 0.005)
		part(root, "FoldedCanopy", Vector3(0.66, 0.048, 0.66), Vector3(-0.17, 0.64, 0), structure)
		part(root, "CanopyLip", Vector3(0.66, 0.050, 0.022), Vector3(-0.17, 0.604, 0.32), structure, 0.005)
		var arrow := SurfaceTool.new()
		arrow.begin(Mesh.PRIMITIVE_TRIANGLES)
		P._flat_line(arrow, Vector2(-0.36, -0.02), Vector2(0.04, -0.02), 0.693, 0.039)
		P._triangle(arrow, Vector3(0.14, 0.694, -0.02), Vector3(-0.01, 0.694, -0.13), Vector3(-0.01, 0.694, 0.09), Vector3.UP)
		P._add_mesh(root, arrow.commit(), material("LetterIvory", T.surface, 0.5)).name = "DispatchArrow"
		badge(root, label, Vector3(-0.16, 0.52, 0.41), 1.08)
	else:
		part(root, "Back", Vector3(0.06, 0.51, 0.51), Vector3(0.34, 0.166, 0), ivory)
		for z: float in [-0.24, 0.24]: part(root, "IntakeSide", Vector3(0.51, 0.51, 0.06), Vector3(0.10, 0.166, z), ivory)
		part(root, "SlopedHead", Vector3(0.43, 0.065, 0.58), Vector3(0.15, 0.67, 0), structure)
		var label_mesh := SurfaceTool.new()
		label_mesh.begin(Mesh.PRIMITIVE_TRIANGLES)
		var points: Array[Vector2] = [Vector2(-0.02, -0.10), Vector2(0.28, -0.10), Vector2(0.28, 0.10), Vector2(-0.02, 0.10)]
		for i in 4: P._flat_line(label_mesh, points[i], points[(i+1)%4], 0.742, 0.017)
		P._flat_line(label_mesh, points[0], Vector2(0.13, 0.025), 0.742, 0.017)
		P._flat_line(label_mesh, points[1], Vector2(0.13, 0.025), 0.742, 0.017)
		P._add_mesh(root, label_mesh.commit(), material("LetterIvory", T.surface, 0.5)).name = "ReceiveEnvelope"
		var lid := Node3D.new()
		lid.name = "ReceptionLid"
		lid.position = Vector3(-0.17, 0.66, 0)
		root.add_child(lid)
		part(lid, "IntakeDoor", Vector3(0.032, 0.47, 0.42), Vector3(0, -0.47, 0), structure)
		part(lid, "MailSlot", Vector3(0.009, 0.047, 0.30), Vector3(-0.02, -0.12, 0), material("SlotDark", Color("14272d"), 0.8), 0.003)
		part(lid, "IntakeLip", Vector3(0.07, 0.022, 0.33), Vector3(-0.03, -0.055, 0), fitting, 0.004)
		badge(root, label, Vector3(0.11, 0.35, 0.32), 1.08)
		var seal := Node3D.new()
		seal.name = "ReceiptSeal"
		seal.position = Vector3(0.10, 0.77, 0.18)
		root.add_child(seal)
		L.cylinder(seal, "AcceptedDisc", 0.12, 0.018, Vector3.ZERO, material("Accepted", T.success, 0.6))
		var tick := SurfaceTool.new()
		tick.begin(Mesh.PRIMITIVE_TRIANGLES)
		P._flat_line(tick, Vector2(-0.07, 0), Vector2(-0.01, 0.05), 0.014, 0.024)
		P._flat_line(tick, Vector2(-0.01, 0.05), Vector2(0.075, -0.06), 0.014, 0.024)
		P._add_mesh(seal, tick.commit(), material("LetterIvory", T.surface, 0.5))
	return root


static func parcel(label: String) -> Node3D:
	var root := Node3D.new()
	root.name = "PostalParcel" + label
	part(root, "KraftCarton", Vector3(0.30, 0.24, 0.25), Vector3.ZERO, material("WarmKraft", Color("c3a77e"), 0.90), 0.021)
	for cross: bool in [true, false]:
		part(root, "FoldedBand", Vector3(0.31 if cross else 0.045, 0.017, 0.044 if cross else 0.26), Vector3(0, 0.238, 0), material("PaperBand", Color("f0e6cd"), 0.90), 0.004)
	badge(root, label, Vector3(0, 0.15, 0.146), 0.72)
	return root


static func plinth() -> Node3D:
	var root := Node3D.new()
	root.name = "WorkshopBed"
	part(root, "SlateFoot", Vector3(6.22, 0.16, 6.22), Vector3(0, -0.19, 0), material("BedSlate", Color("7c9690"), 0.66), 0.035)
	part(root, "FlushIvoryEdge", Vector3(6.17, 0.038, 6.17), Vector3(0, -0.034, 0), material("BedIvory", Color("deded2"), 0.64), 0.010)
	return root


static func color_tracks(root: Node3D, label: String) -> void:
	for node: Node in root.find_children("*", "MeshInstance3D", true, false):
		var mesh := node as MeshInstance3D
		var m: Material = mesh.material_override if mesh.material_override != null else mesh.mesh.surface_get_material(0)
		if m != null and m.resource_name == "PaintedMetal":
			mesh.material_override = material("Track" + label, T.primary if label == "A" else T.address_b.darkened(0.06), 0.32, 0.12)
