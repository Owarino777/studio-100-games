class_name LittoralModels
extends RefCounted
## Editable native geometry. No reference-image pixels or paid generation.
## Coordinates and ports match PostalLevel. Save sources before batching for GLB.

const BASE = preload("res://scripts/visuals/postal_art_factory.gd")
const INK = Color("173b54")
const CREAM = Color("f5e7c9")
const STONE = Color("d9c6a6")
const BLUE = Color("347aa6")
const CORAL = Color("c96d4b")
static var materials: Dictionary[String, StandardMaterial3D] = {}


static func mat(id: String, color: Color, roughness: float, metallic: float = 0.0) -> StandardMaterial3D:
	var key: String = id + color.to_html()
	if materials.has(key): return materials[key]
	var result := StandardMaterial3D.new()
	result.resource_name = id
	# LDR Compatibility needs highlight headroom, especially after glTF linear/sRGB
	# round trips. Pale surfaces must keep a visible warm body, never clip to white.
	result.albedo_color = color.darkened(0.22) if color.get_luminance() > 0.55 else color
	result.roughness = roughness
	result.metallic = metallic
	result.cull_mode = BaseMaterial3D.CULL_DISABLED
	materials[key] = result
	return result


static func piece(parent: Node3D, id: String, size: Vector3, at: Vector3, material: Material, bevel: float = 0.018) -> MeshInstance3D:
	var mesh: ArrayMesh = BASE._rounded_prism(size.x, size.z, size.y, minf(size.x, size.z) * 0.16, minf(bevel, size.y * 0.23))
	var node: MeshInstance3D = BASE._add_mesh(parent, mesh, material, at)
	node.name = id
	return node


static func text(parent: Node3D, value: String, at: Vector3, height: float, color: Color, tilt: float = -35.0) -> void:
	# Simple authored A/B glyph strokes survive GLB. TextMesh rejected the variable
	# font's self-intersecting outlines; HUD text still uses the licensed real font.
	var paths: Array[PackedVector2Array] = []
	if value == "A":
		paths = [PackedVector2Array([Vector2(-0.30, 0.45), Vector2(0, -0.45), Vector2(0.30, 0.45)]), PackedVector2Array([Vector2(-0.20, 0.15), Vector2(0.20, 0.15)])]
	else:
		paths.append(PackedVector2Array([Vector2(-0.25, -0.45), Vector2(-0.25, 0.45)]))
		for center_y: float in [-0.225, 0.225]:
			var arc := PackedVector2Array([Vector2(-0.25, center_y - 0.225)])
			for i in 13:
				var angle: float = -PI * 0.5 + float(i) / 12.0 * PI
				arc.append(Vector2(-0.06 + cos(angle) * 0.32, center_y + sin(angle) * 0.225))
			arc.append(Vector2(-0.25, center_y + 0.225))
			paths.append(arc)
	var tool := SurfaceTool.new()
	tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	for path: PackedVector2Array in paths:
		for i in path.size() - 1: BASE._flat_line(tool, path[i] * height, path[i + 1] * height, 0, height * 0.105)
	var node: MeshInstance3D = BASE._add_mesh(parent, tool.commit(), mat("SignalInk", color, 0.75), at)
	node.name = "Letter" + value
	node.rotation_degrees.x = 90.0 + tilt
	node.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF


static func tube(parent: Node3D, id: String, points: PackedVector3Array, radius: float, height: float, material: Material) -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	BASE._tube(st, points, radius, height)
	BASE._add_mesh(parent, st.commit(), material).name = id


static func cylinder(parent: Node3D, id: String, radius: float, height: float, at: Vector3, material: Material) -> MeshInstance3D:
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius
	mesh.bottom_radius = radius * 0.96
	mesh.height = height
	mesh.radial_segments = 20
	var node: MeshInstance3D = BASE._add_mesh(parent, mesh, material, at)
	node.name = id
	return node


static func badge(parent: Node3D, label: String, at: Vector3, color: Color) -> void:
	var root := Node3D.new()
	root.name = "AddressBadge" + label
	root.position = at
	root.rotation_degrees.x = -32.0
	parent.add_child(root)
	# Sign lies in XY; letter and coloured geometric border share a readable face.
	var plate: MeshInstance3D = piece(root, "PorcelainSign", Vector3(0.33, 0.025, 0.31), Vector3.ZERO, mat("PorcelainSign", CREAM, 0.25))
	plate.rotation_degrees.x = 90.0
	plate.position.y = 0.0
	var symbol: Mesh
	if label == "A":
		var circle := CylinderMesh.new()
		circle.top_radius = 0.129
		circle.bottom_radius = 0.129
		circle.height = 0.008
		circle.radial_segments = 32
		symbol = circle
	else:
		symbol = BASE._triangle_mesh(0.27, 0.265, 0.008)
	var shape: MeshInstance3D = BASE._add_mesh(root, symbol, mat("Address" + label, color, 0.34), Vector3(0, 0, 0.035))
	shape.rotation_degrees.x = 90.0
	text(root, label, Vector3(0, -0.005, 0.048), 0.265, CREAM, 0)


static func envelope(parent: Node3D, at: Vector3, scale_factor: float, color: Color) -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var corners: Array[Vector2] = [Vector2(-0.13, -0.08), Vector2(0.13, -0.08), Vector2(0.13, 0.08), Vector2(-0.13, 0.08)]
	for i in 4:
		BASE._flat_line(st, corners[i] * scale_factor, corners[(i + 1) % 4] * scale_factor, 0, 0.013 * scale_factor)
	BASE._flat_line(st, corners[0] * scale_factor, Vector2(0, 0.03) * scale_factor, 0, 0.013 * scale_factor)
	BASE._flat_line(st, corners[1] * scale_factor, Vector2(0, 0.03) * scale_factor, 0, 0.013 * scale_factor)
	var node: MeshInstance3D = BASE._add_mesh(parent, st.commit(), mat("SignalInk", color, 0.75), at)
	node.name = "Envelope"
	node.rotation_degrees.x = 66


static func roof_patch(parent: Node3D, id: String, x_center: float, z0: float, z1: float, start: float, end: float, radius: float, base_y: float, rise: float, material: Material) -> void:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for i in 8:
		var a: float = lerpf(start, end, float(i) / 8.0)
		var b: float = lerpf(start, end, float(i + 1) / 8.0)
		var p := Vector3(x_center + cos(a) * radius, base_y + sin(a) * rise, z0)
		var q := Vector3(x_center + cos(b) * radius, base_y + sin(b) * rise, z0)
		var r := Vector3(q.x, q.y, z1)
		var s := Vector3(p.x, p.y, z1)
		var na := Vector3(cos(a) / radius, sin(a) / rise, 0).normalized()
		var nb := Vector3(cos(b) / radius, sin(b) / rise, 0).normalized()
		# Godot front faces are clockwise. A reversed roof can render as a flat,
		# dark back face even when the normal array appears mathematically correct.
		BASE._smooth_triangle(st, p, r, q, na, nb, nb)
		BASE._smooth_triangle(st, p, s, r, na, na, nb)
		BASE._quad(st, p, q, q - Vector3(0, 0.018, 0), p - Vector3(0, 0.018, 0), Vector3.FORWARD)
		BASE._quad(st, s, s - Vector3(0, 0.018, 0), r - Vector3(0, 0.018, 0), r, Vector3.BACK)
	BASE._add_mesh(parent, st.commit(), material).name = id


static func tile() -> Node3D:
	var root := Node3D.new()
	root.name = "LimestoneTile"
	piece(root, "StoneFoot", Vector3(0.975, 0.105, 0.975), Vector3.ZERO, mat("LimestoneFoot", Color("c1b294"), 0.82), 0.028)
	piece(root, "GlazedBevel", Vector3(0.963, 0.034, 0.963), Vector3(0, 0.087, 0), mat("GlazedBevel", CREAM, 0.25), 0.011)
	piece(root, "CalmStoneCrown", Vector3(0.905, 0.014, 0.905), Vector3(0, 0.116, 0), mat("LimestoneCrown", Color("ebd8b2"), 0.72), 0.004)
	return root


static func rail(straight: bool) -> Node3D:
	var root := Node3D.new()
	root.name = "Straight" if straight else "Elbow"
	for offset: float in [-0.10, 0.10]:
		var path := PackedVector3Array()
		for i in (2 if straight else 25):
			var t: float = float(i) / (1.0 if straight else 24.0)
			var a: float = PI - t * PI * 0.5
			path.append(Vector3(offset, 0.175, lerpf(-0.5, 0.5, t)) if straight else Vector3(0.5 + cos(a) * (0.5 + offset), 0.175, -0.5 + sin(a) * (0.5 + offset)))
		tube(root, "PaintedRail", path, 0.038, 0.027, mat("PaintedMetal", INK, 0.34, 0.12))
		for j in path.size(): path[j].y += 0.021
		tube(root, "RailGlint", path, 0.013, 0.008, mat("RailGlint", Color("83a4ad"), 0.27, 0.18))
	for i in 5:
		var t: float = (float(i) + 0.5) / 5.0
		var a: float = PI - t * PI * 0.5
		var at: Vector3 = Vector3(0, 0.130, lerpf(-0.5, 0.5, t)) if straight else Vector3(0.5 + cos(a) * 0.5, 0.130, -0.5 + sin(a) * 0.5)
		var tie: MeshInstance3D = piece(root, "OakSleeper", Vector3(0.34, 0.029, 0.074), at, mat("HoneyWood", Color("b58d58"), 0.65), 0.008)
		tie.rotation.y = 0 if straight else -a
	for mask: int in ([1, 4] if straight else [1, 2]):
		var port := Node3D.new()
		port.name = "Port%d" % mask
		port.position = Vector3(0, 0.175, -0.5) if mask == 1 else (Vector3(0, 0.175, 0.5) if mask == 4 else Vector3(0.5, 0.175, 0))
		root.add_child(port)
	return root


static func platform(root: Node3D) -> void:
	piece(root, "LimestonePlinth", Vector3(0.90, 0.065, 0.85), Vector3(0, 0.126, 0), mat("Limestone", STONE, 0.82), 0.018)
	for i in 4:
		piece(root, "CutStone", Vector3(0.20, 0.050, 0.10), Vector3(-0.33 + float(i) * 0.22, 0.18, 0.36), mat("Limestone", STONE, 0.82), 0.011)


static func station(label: String, source: bool) -> Node3D:
	var root := Node3D.new()
	root.name = ("Guichet" if source else "Boite") + label
	root.set_meta("role", "dispatch" if source else "reception")
	root.set_meta("address_label", label)
	root.set_meta("ports", 2 if source else 8)
	var color: Color = BLUE if label == "A" else CORAL
	platform(root)
	var stone: StandardMaterial3D = mat("Limestone", STONE, 0.82)
	var ivory: StandardMaterial3D = mat("Porcelain", CREAM, 0.30)
	var enamel: StandardMaterial3D = mat("Enamel" + label, color, 0.24)
	var dark: StandardMaterial3D = mat("PaintedMetal", INK, 0.34, 0.12)
	var wood: StandardMaterial3D = mat("HoneyWood", Color("b58d58"), 0.65)
	# Only the real E/W connection exists. Never display a full rail through a wall.
	for z: float in [-0.10, 0.10]:
		var x0: float = 0.02 if source else -0.50
		var x1: float = 0.50 if source else 0.04
		tube(root, "PortRail", PackedVector3Array([Vector3(x0, 0.175, z), Vector3(x1, 0.175, z)]), 0.038, 0.027, dark)
	var port := Node3D.new()
	port.name = "Port2" if source else "Port8"
	port.position = Vector3(0.5 if source else -0.5, 0.175, 0)
	root.add_child(port)
	if source:
		# A wall at the back and posts around the real east-facing open portal.
		piece(root, "WestWall", Vector3(0.075, 0.43, 0.56), Vector3(-0.39, 0.19, 0), ivory)
		piece(root, "BackWall", Vector3(0.54, 0.43, 0.075), Vector3(-0.14, 0.19, -0.26), ivory)
		piece(root, "ServiceRecess", Vector3(0.40, 0.30, 0.035), Vector3(-0.14, 0.23, 0.24), dark)
		piece(root, "Counter", Vector3(0.55, 0.065, 0.12), Vector3(-0.14, 0.25, 0.29), wood)
		for x: float in [-0.40, 0.12]:
			piece(root, "StoneJamb", Vector3(0.075, 0.43, 0.085), Vector3(x, 0.19, 0.26), stone)
			piece(root, "AwningPost", Vector3(0.035, 0.32, 0.035), Vector3(x, 0.23, 0.40), wood, 0.005)
		piece(root, "EastLintel", Vector3(0.065, 0.10, 0.55), Vector3(0.12, 0.54, 0), ivory)
		for row in 4:
			for col in 7:
				var roof_mat: StandardMaterial3D = mat("Enamel" + label + str((col + row) % 3), color.lightened(float((col + row) % 3) * 0.035), 0.24)
				roof_patch(root, "GlazedRoofTile", -0.20, -0.34 + float(row) * 0.17, -0.34 + float(row + 1) * 0.17 - 0.006, float(col) * PI / 7.0 + 0.009, float(col + 1) * PI / 7.0 - 0.009, 0.33, 0.60, 0.20, roof_mat)
		roof_patch(root, "RoofFasciaFront", -0.20, 0.335, 0.367, 0, PI, 0.34, 0.585, 0.195, enamel)
		for stripe in 7:
			var strip: MeshInstance3D = piece(root, "CanvasStripe", Vector3(0.081, 0.018, 0.23), Vector3(-0.39 + float(stripe) * 0.083, 0.555, 0.33), mat("Canvas" + str(stripe % 2), Color("efbd68") if stripe % 2 == 0 else CREAM, 0.91), 0.004)
			strip.rotation_degrees.x = 18
			piece(root, "CanvasValance", Vector3(0.081, 0.065, 0.012), Vector3(-0.39 + float(stripe) * 0.083, 0.474, 0.448), strip.material_override, 0.004)
		piece(root, "Chimney", Vector3(0.10, 0.18, 0.10), Vector3(-0.39, 0.69, -0.19), stone)
		piece(root, "ChimneyCap", Vector3(0.14, 0.03, 0.14), Vector3(-0.39, 0.86, -0.19), enamel, 0.006)
		# Raised dispatch arrow visible on the front edge, aligned with the real port.
		var arrow := SurfaceTool.new()
		arrow.begin(Mesh.PRIMITIVE_TRIANGLES)
		BASE._flat_line(arrow, Vector2(0.13, 0.32), Vector2(0.37, 0.32), 0.20, 0.034)
		BASE._triangle(arrow, Vector3(0.43, 0.203, 0.32), Vector3(0.31, 0.203, 0.25), Vector3(0.31, 0.203, 0.39), Vector3.UP)
		BASE._add_mesh(root, arrow.commit(), dark).name = "DispatchArrow"
		badge(root, label, Vector3(-0.17, 0.76, 0.405), color)
		var lantern: StandardMaterial3D = mat("LanternAmber", Color("f4c775"), 0.60)
		piece(root, "WallLantern", Vector3(0.065, 0.12, 0.055), Vector3(-0.435, 0.35, 0.33), lantern, 0.011)
		piece(root, "LanternCap", Vector3(0.09, 0.026, 0.075), Vector3(-0.435, 0.47, 0.33), dark, 0.006)
	else:
		piece(root, "BackShell", Vector3(0.065, 0.45, 0.53), Vector3(0.34, 0.19, 0), ivory)
		for z: float in [-0.255, 0.255]:
			piece(root, "BoxSide", Vector3(0.50, 0.45, 0.065), Vector3(0.10, 0.19, z), ivory)
		roof_patch(root, "VaultedEnamelHood", 0.10, -0.31, 0.31, 0, PI, 0.31, 0.62, 0.20, enamel)
		roof_patch(root, "HoodLip", 0.10, 0.31, 0.345, 0, PI, 0.33, 0.60, 0.21, enamel)
		var lid := Node3D.new()
		lid.name = "ReceptionLid"
		lid.position = Vector3(-0.18, 0.64, 0)
		root.add_child(lid)
		piece(lid, "HingedDoor", Vector3(0.035, 0.42, 0.45), Vector3(0, -0.42, 0), enamel)
		piece(lid, "MailSlot", Vector3(0.012, 0.048, 0.31), Vector3(-0.022, -0.13, 0), dark, 0.004)
		piece(lid, "SlotLip", Vector3(0.046, 0.025, 0.34), Vector3(-0.027, -0.077, 0), mat("BrassDetail", Color("d7a04c"), 0.36, 0.18), 0.006)
		badge(root, label, Vector3(0.11, 0.38, 0.32), color)
		var plaque: MeshInstance3D = piece(root, "EnvelopePlaque", Vector3(0.28, 0.024, 0.18), Vector3(0.10, 0.75, 0.388), ivory, 0.006)
		plaque.rotation_degrees.x = 66
		envelope(root, Vector3(0.10, 0.75, 0.418), 0.78, INK)
		var seal := Node3D.new()
		seal.name = "ReceiptSeal"
		seal.position = Vector3(0.09, 0.83, 0.20)
		root.add_child(seal)
		cylinder(seal, "ConfirmationDisc", 0.14, 0.025, Vector3.ZERO, mat("Success", Color("3e7557"), 0.65))
		var check := SurfaceTool.new()
		check.begin(Mesh.PRIMITIVE_TRIANGLES)
		BASE._flat_line(check, Vector2(-0.075, 0.0), Vector2(-0.015, 0.06), 0.018, 0.030)
		BASE._flat_line(check, Vector2(-0.015, 0.06), Vector2(0.084, -0.066), 0.018, 0.030)
		BASE._add_mesh(seal, check.commit(), mat("Porcelain", CREAM, 0.30))
	return root


static func parcel(label: String) -> Node3D:
	var root := Node3D.new()
	root.name = "KraftParcel" + label
	var paper: StandardMaterial3D = mat("Kraft", Color("d6ac70"), 0.91)
	piece(root, "FoldedCarton", Vector3(0.30, 0.24, 0.25), Vector3.ZERO, paper, 0.025)
	piece(root, "CrossBand", Vector3(0.32, 0.025, 0.042), Vector3(0, 0.239, 0), mat("Canvas1", CREAM, 0.91), 0.006)
	piece(root, "RibbonFold", Vector3(0.047, 0.025, 0.26), Vector3(0, 0.239, 0), mat("Canvas1", CREAM, 0.91), 0.006)
	var flap: MeshInstance3D = BASE._add_mesh(root, BASE._triangle_mesh(0.25, 0.09, 0.005), mat("KraftFold", Color("e2bd86"), 0.91), Vector3(0, 0.243, -0.065))
	flap.name = "PaperFlap"
	badge(root, label, Vector3(0, 0.15, 0.147), BLUE if label == "A" else CORAL)
	# Parcel label plate is deliberately smaller than station signage.
	var plate: Node3D = root.get_node("AddressBadge" + label)
	plate.scale = Vector3.ONE * 0.64
	return root


static func island() -> Node3D:
	var root := Node3D.new()
	root.name = "LittoralPlinth"
	piece(root, "SeaShadow", Vector3(6.58, 0.13, 6.58), Vector3(0, -0.40, 0), mat("SeaShadow", Color("5f969e"), 0.8), 0.03)
	piece(root, "StoneBase", Vector3(6.45, 0.25, 6.45), Vector3(0, -0.32, 0), mat("Limestone", STONE, 0.82), 0.06)
	piece(root, "EnamelBorder", Vector3(6.39, 0.08, 6.39), Vector3(0, -0.08, 0), mat("BorderEnamel", Color("abc4be"), 0.28), 0.025)
	for side: float in [-1.0, 1.0]:
		for i in 14:
			piece(root, "QuayStone", Vector3(0.43, 0.10, 0.20), Vector3(-2.95 + float(i) * 0.455, -0.015, side * 3.12), mat("Limestone", STONE, 0.82), 0.025)
	return root


static func batch_static(root: Node3D) -> void:
	# Used only for immutable island/decor, never for doors, parcels or rail pivots.
	var groups: Dictionary = {}
	_collect_static(root, Transform3D.IDENTITY, groups, true)
	for child: Node in root.get_children():
		root.remove_child(child)
		child.free()
	for material: Material in groups:
		var tool: SurfaceTool = groups[material]
		BASE._add_mesh(root, tool.commit(), material).name = "Static_" + material.resource_name


static func normalize_geometry(root: Node3D) -> void:
	# Make the editable source itself consistent, before saving TSCN or GLB.
	# Surface normals are the authored intent; Godot triangles must be clockwise.
	for node: Node in root.find_children("*", "MeshInstance3D", true, false):
		var instance := node as MeshInstance3D
		var clean := ArrayMesh.new()
		for surface in instance.mesh.get_surface_count():
			var arrays: Array = instance.mesh.surface_get_arrays(surface)
			var vertices: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
			var normals: PackedVector3Array = arrays[Mesh.ARRAY_NORMAL]
			var uv: Variant = arrays[Mesh.ARRAY_TEX_UV]
			var indices: Variant = arrays[Mesh.ARRAY_INDEX]
			var order: PackedInt32Array = indices if indices is PackedInt32Array else PackedInt32Array()
			if order.is_empty():
				for i in vertices.size(): order.append(i)
			var tool := SurfaceTool.new()
			tool.begin(Mesh.PRIMITIVE_TRIANGLES)
			for offset in range(0, order.size(), 3):
				var a: int = order[offset]
				var b: int = order[offset + 1]
				var c: int = order[offset + 2]
				var cross: Vector3 = (vertices[b] - vertices[a]).cross(vertices[c] - vertices[a])
				if cross.length() < 0.0000000001: continue
				if cross.dot(normals[a] + normals[b] + normals[c]) > 0:
					var swap: int = b
					b = c
					c = swap
				for i: int in [a, b, c]:
					tool.set_normal(normals[i])
					if uv is PackedVector2Array and uv.size() == vertices.size(): tool.set_uv(uv[i])
					tool.add_vertex(vertices[i])
			tool.commit(clean)
			clean.surface_set_material(surface, instance.mesh.surface_get_material(surface))
		instance.mesh = clean


static func _collect_static(node: Node3D, parent_transform: Transform3D, groups: Dictionary, first: bool = false) -> void:
	var transform: Transform3D = parent_transform if first else parent_transform * node.transform
	if node is MeshInstance3D:
		var instance := node as MeshInstance3D
		for surface in instance.mesh.get_surface_count():
			var material: Material = instance.material_override if instance.material_override != null else instance.mesh.surface_get_material(surface)
			if not groups.has(material):
				var tool := SurfaceTool.new()
				tool.begin(Mesh.PRIMITIVE_TRIANGLES)
				groups[material] = tool
			groups[material].append_from(instance.mesh, surface, transform)
	for child: Node in node.get_children():
		if child is Node3D: _collect_static(child, transform, groups)
