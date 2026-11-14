class_name PostalArtFactory
extends RefCounted
## Reusable, authored 3D art for the experimental Archipel Postal scene.
## Coordinates: +X east, -Z north, +Y up. A cell is one world unit.

const PORCELAIN: Color = Color("#f5efe2")
const INK: Color = Color("#203c56")
const BLUE: Color = Color("#7095cf")
const CORAL: Color = Color("#e78f70")
const CELADON: Color = Color("#79beb5")
const PAPER: Color = Color("#f5ddb1")
const CERAMIC_TEXTURE: Texture2D = preload("res://assets/archipel/textures/porcelain-albedo-v1.png")
const PAPER_TEXTURE: Texture2D = preload("res://assets/archipel/textures/paper-albedo-v1.png")
const WHITE_PAPER_GRAIN: Texture2D = preload("res://assets/archipel/textures/paper_fibres.svg")

static var _materials: Dictionary[String, StandardMaterial3D] = {}
static var _meshes: Dictionary[String, ArrayMesh] = {}
static var _font: Font = null


static func configure_font(font: Font) -> void:
	_font = font


static func create_tile() -> Node3D:
	var root := Node3D.new()
	root.name = "PorcelainTile"
	var mat := _material("porcelain", PORCELAIN, 0.32)
	mat.albedo_texture = CERAMIC_TEXTURE
	_add_mesh(root, _rounded_prism(0.972, 0.972, 0.12, 0.085, 0.022), mat).name = "GlazedTile"
	return root


static func create_rail(ports: int, color: Color = INK) -> Node3D:
	var root := Node3D.new()
	root.name = "Rail_%d" % ports
	root.set_meta("ports", ports)
	var straight: bool = ports == 5 or ports == 10
	var orientation: float = 0.0
	if straight:
		orientation = PI * 0.5 if ports == 10 else 0.0
	else:
		match ports:
			3: orientation = 0.0
			6: orientation = -PI * 0.5
			12: orientation = -PI
			9: orientation = -PI * 1.5
			_: return root
	root.rotation.y = orientation
	var key: String = "straight" if straight else "elbow"
	if not _meshes.has(key + "_rails"):
		_build_rail_meshes(straight, key)
	var mat := _material("rail", color, 0.28, 0.22)
	_add_mesh(root, _meshes[key + "_sleepers"], _material("sleepers", Color("#dfd8c8"), 0.44)).name = "Sleepers"
	_add_mesh(root, _meshes[key + "_rails"], mat).name = "EnamelRails"
	return root


static func create_station(label: String, is_source: bool, color: Color) -> Node3D:
	var root := Node3D.new()
	root.name = ("Source" if is_source else "Reception") + label
	root.set_meta("address_label", label)
	root.set_meta("is_source", is_source)
	root.set_meta("port", "E" if is_source else "W")
	# The opening is genuinely on the east face; rotate the complete destination west.
	if not is_source:
		root.rotation.y = PI
	var ceramic := _material("station_ceramic", PORCELAIN, 0.34)
	ceramic.albedo_texture = CERAMIC_TEXTURE
	var paper := _material("paper", PAPER, 0.82)
	paper.albedo_texture = PAPER_TEXTURE
	var roof_mat := _material("roof", color.lightened(0.12), 0.62)
	# Neutral fibre stock keeps blue/coral paper from turning brown under daylight.
	roof_mat.albedo_texture = WHITE_PAPER_GRAIN
	roof_mat.vertex_color_use_as_albedo = true
	_add_mesh(root, _rounded_prism(0.90, 0.85, 0.075, 0.13, 0.017), ceramic, Vector3(0.0, 0.12, 0.0))
	# A low pavilion sits behind the platform, leaving the cargo visibly on its porch.
	_add_mesh(root, _rounded_prism(0.075, 0.59, 0.37, 0.017, 0.008), paper, Vector3(-0.37, 0.195, 0.0))
	_add_mesh(root, _rounded_prism(0.50, 0.065, 0.35, 0.018, 0.008), paper, Vector3(-0.12, 0.195, -0.285))
	_add_mesh(root, _rounded_prism(0.50, 0.065, 0.35, 0.018, 0.008), paper, Vector3(-0.12, 0.195, 0.285))
	_add_mesh(root, _rounded_prism(0.075, 0.12, 0.31, 0.018, 0.008), paper, Vector3(0.13, 0.195, -0.235))
	_add_mesh(root, _rounded_prism(0.075, 0.12, 0.31, 0.018, 0.008), paper, Vector3(0.13, 0.195, 0.235))
	# Shadowed interior and a continuation of the two rails make the port unambiguous.
	_add_mesh(root, _rounded_prism(0.015, 0.31, 0.22, 0.012, 0.004), _material("interior", Color("#294859"), 0.92), Vector3(-0.30, 0.20, 0.0))
	var station_track := create_rail(10, color.darkened(0.12))
	station_track.name = "StationTrack"
	# Keep the physical port height identical to the neighbouring rotatable rail.
	root.add_child(station_track)
	var roof := _add_mesh(root, _roof_mesh(), roof_mat, Vector3(-0.23, 0.545, 0.0))
	roof.name = "FoldedRoof"
	roof.rotation.y = PI * 0.5
	# Raised folds remain separate geometry, rather than a painted roof illusion.
	_add_mesh(root, _rounded_prism(0.035, 0.69, 0.024, 0.01, 0.006), _material("roof_seam", color.lightened(0.30), 0.70), Vector3(-0.23, 0.80, 0.0))
	var sign := _badge(label, color, 0.34, false)
	# A single tilted postal sign remains readable without a duplicate label on the floor.
	sign.position = Vector3(-0.23, 0.73, 0.42 if is_source else -0.42)
	sign.basis = Basis(Vector3.RIGHT, PI * 0.25) if is_source else Basis(Vector3.UP, PI) * Basis(Vector3.RIGHT, PI * 0.25)
	root.add_child(sign)
	return root


static func create_parcel(label: String, color: Color) -> Node3D:
	var root := Node3D.new()
	root.name = "Parcel" + label
	root.set_meta("address_label", label)
	root.set_meta("shape", "triangle" if label == "B" else "circle")
	var visual := Node3D.new()
	visual.name = "PaperCarton"
	visual.scale = Vector3.ONE * 1.20
	root.add_child(visual)
	var paper := _material("parcel_paper", Color("#e7c58f"), 0.92)
	paper.albedo_texture = PAPER_TEXTURE
	_add_mesh(visual, _rounded_prism(0.34, 0.285, 0.245, 0.023, 0.012), paper)
	var band := _material("parcel_band", Color("#fcf0d4"), 0.94)
	_add_mesh(visual, _rounded_prism(0.055, 0.29, 0.012, 0.005, 0.003), band, Vector3(0.0, 0.245, 0.0))
	_add_mesh(visual, _rounded_prism(0.345, 0.045, 0.009, 0.004, 0.002), band, Vector3(0.0, 0.257, 0.0))
	# A folded triangular flap and its seam give the carton a paper construction.
	var flap := _triangle_mesh(0.29, 0.10, 0.007)
	_add_mesh(visual, flap, _material("parcel_flap", Color("#f1d6a7"), 0.86), Vector3(0.0, 0.248, -0.065))
	var badge := _badge(label, color, 0.25, true, true)
	badge.position = Vector3(0.0, 0.269, 0.012)
	visual.add_child(badge)
	return root


static func create_island() -> Node3D:
	var root := Node3D.new()
	root.name = "PorcelainIsland"
	var side := _material("island_side", Color("#e0d6bf"), 0.44)
	side.albedo_texture = CERAMIC_TEXTURE
	_add_mesh(root, _rounded_prism(6.42, 6.42, 0.36, 0.40, 0.065), side, Vector3(0.0, -0.40, 0.0))
	_add_mesh(root, _rounded_prism(6.48, 6.48, 0.075, 0.42, 0.025), _material("island_rim", PORCELAIN, 0.28), Vector3(0.0, -0.05, 0.0))
	_add_mesh(root, _rounded_prism(6.30, 6.30, 0.035, 0.34, 0.010), _material("island_inner", Color("#d1ded3"), 0.48), Vector3(0.0, 0.018, 0.0))
	return root


static func create_flower() -> Node3D:
	var root := Node3D.new()
	root.name = "PaperFlower"
	var pot := CylinderMesh.new()
	pot.top_radius = 0.15
	pot.bottom_radius = 0.11
	pot.height = 0.18
	pot.radial_segments = 16
	_add_mesh(root, pot, _material("flower_pot", PORCELAIN, 0.34), Vector3(0.0, 0.09, 0.0))
	var stem := CylinderMesh.new()
	stem.top_radius = 0.015
	stem.bottom_radius = 0.022
	stem.height = 0.38
	stem.radial_segments = 8
	_add_mesh(root, stem, _material("stem", Color("#76a68e"), 0.84), Vector3(0.0, 0.35, 0.0))
	var petal := SphereMesh.new()
	petal.radius = 0.10
	petal.height = 0.08
	petal.radial_segments = 12
	petal.rings = 6
	for i in 5:
		var angle: float = TAU * float(i) / 5.0
		var instance := _add_mesh(root, petal, _material("petal", Color("#edaa7d"), 0.78), Vector3(cos(angle) * 0.10, 0.57, sin(angle) * 0.10))
		instance.scale = Vector3(1.0, 1.0, 1.35)
		instance.rotation.y = -angle
	var middle := SphereMesh.new()
	middle.radius = 0.055
	middle.height = 0.055
	middle.radial_segments = 12
	middle.rings = 6
	_add_mesh(root, middle, _material("pollen", Color("#e8bd6c"), 0.80), Vector3(0.0, 0.59, 0.0))
	var leaf := SphereMesh.new()
	leaf.radius = 0.10
	leaf.height = 0.035
	leaf.radial_segments = 12
	leaf.rings = 6
	for side: float in [-1.0, 1.0]:
		var instance := _add_mesh(root, leaf, _material("leaf", CELADON.darkened(0.12), 0.76), Vector3(side * 0.085, 0.34, 0.0))
		instance.scale = Vector3(1.5, 1.0, 0.65)
		instance.rotation.z = side * 0.4
	return root


static func create_cloud() -> Node3D:
	var root := Node3D.new()
	root.name = "CloudCluster"
	var sphere := SphereMesh.new()
	sphere.radius = 0.5
	sphere.height = 0.65
	sphere.radial_segments = 16
	sphere.rings = 8
	for i in 5:
		var instance := _add_mesh(root, sphere, _material("cloud", Color("#f3f4ed"), 1.0), Vector3(float(i - 2) * 0.48, sin(float(i) * 1.7) * 0.08, cos(float(i) * 2.3) * 0.12))
		instance.scale = Vector3(1.0, 0.65, 0.80)
		instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	return root


static func create_selection(color: Color = INK) -> Node3D:
	var root := Node3D.new()
	root.name = "TileSelection"
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for sx: float in [-1.0, 1.0]:
		for sz: float in [-1.0, 1.0]:
			_append_box(st, Vector3(0.23, 0.025, 0.035), Transform3D(Basis.IDENTITY, Vector3(sx * 0.325, 0.145, sz * 0.425)))
			_append_box(st, Vector3(0.035, 0.025, 0.23), Transform3D(Basis.IDENTITY, Vector3(sx * 0.425, 0.145, sz * 0.325)))
	_add_mesh(root, st.commit(), _material("selection", color, 0.62)).name = "CornerBrackets"
	return root


static func _material(id: String, color: Color, roughness: float, metallic: float = 0.0) -> StandardMaterial3D:
	var key: String = id + color.to_html()
	if _materials.has(key):
		return _materials[key]
	var mat := StandardMaterial3D.new()
	mat.resource_name = id
	# Reserve highlight headroom for pale surfaces in the Compatibility renderer.
	mat.albedo_color = color.darkened(0.18) if id in ["porcelain", "station_ceramic", "island_rim", "island_side", "badge_paper", "paper"] else color
	mat.roughness = roughness
	mat.metallic = metallic
	mat.cull_mode = BaseMaterial3D.CULL_DISABLED
	_materials[key] = mat
	return mat


static func _add_mesh(parent: Node3D, mesh: Mesh, material: Material, at: Vector3 = Vector3.ZERO) -> MeshInstance3D:
	var instance := MeshInstance3D.new()
	instance.mesh = mesh
	instance.material_override = material
	instance.position = at
	parent.add_child(instance)
	return instance


static func _badge(label: String, color: Color, size: float, horizontal: bool, kraft_backing: bool = false) -> Node3D:
	var root := Node3D.new()
	root.name = "AddressBadge" + label
	root.set_meta("shape", "triangle" if label == "B" else "circle")
	root.set_meta("address_label", label)
	var plate := _rounded_prism(size * (0.98 if kraft_backing else 1.13), size * (1.0 if kraft_backing else 1.15), 0.012, size * 0.14, 0.003)
	var backing := _material("parcel_paper", Color("#e7c58f"), 0.92) if kraft_backing else _material("badge_paper", Color("#fff6e2"), 0.83)
	_add_mesh(root, plate, backing)
	if label == "B":
		_add_mesh(root, _triangle_mesh(size * 0.82, size * 0.78, 0.008), _material("badge_ink", color, 0.60), Vector3(0.0, 0.014, 0.0))
	else:
		var circle := CylinderMesh.new()
		circle.top_radius = size * 0.39
		circle.bottom_radius = size * 0.39
		circle.height = 0.008
		circle.radial_segments = 24
		_add_mesh(root, circle, _material("badge_ink", color, 0.60), Vector3(0.0, 0.019, 0.0))
	var text := Label3D.new()
	text.text = label
	text.font_size = 64
	text.pixel_size = size * 0.016
	text.modulate = INK
	text.outline_size = 0
	text.no_depth_test = false
	text.shaded = false
	text.rotation_degrees.x = -90.0
	text.position = Vector3(0.0, 0.027, 0.0)
	if _font != null:
		text.font = _font
	root.add_child(text)
	if not horizontal:
		root.rotation.z = 0.0
	return root


static func _outline(width: float, depth: float, radius: float) -> PackedVector2Array:
	var result := PackedVector2Array()
	var centers: Array[Vector2] = [Vector2(width * 0.5 - radius, depth * 0.5 - radius), Vector2(-width * 0.5 + radius, depth * 0.5 - radius), Vector2(-width * 0.5 + radius, -depth * 0.5 + radius), Vector2(width * 0.5 - radius, -depth * 0.5 + radius)]
	for corner in 4:
		for step in 5:
			var angle: float = float(corner) * PI * 0.5 + float(step) * PI * 0.125
			result.append(centers[corner] + Vector2(cos(angle), sin(angle)) * radius)
	return result


static func _rounded_prism(width: float, depth: float, height: float, radius: float, bevel: float) -> ArrayMesh:
	var key: String = "bevel_%f_%f_%f_%f_%f" % [width, depth, height, radius, bevel]
	if _meshes.has(key):
		return _meshes[key]
	var outer: PackedVector2Array = _outline(width, depth, radius)
	var inner: PackedVector2Array = _outline(width - bevel * 2.0, depth - bevel * 2.0, maxf(radius - bevel, 0.002))
	var loops: Array[PackedVector2Array] = [inner, outer, outer, inner]
	var ys: Array[float] = [0.0, bevel, height - bevel, height]
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for ring in 3:
		for i in outer.size():
			var j: int = (i + 1) % outer.size()
			var a := Vector3(loops[ring][i].x, ys[ring], loops[ring][i].y)
			var b := Vector3(loops[ring][j].x, ys[ring], loops[ring][j].y)
			var c := Vector3(loops[ring + 1][j].x, ys[ring + 1], loops[ring + 1][j].y)
			var d := Vector3(loops[ring + 1][i].x, ys[ring + 1], loops[ring + 1][i].y)
			var outward := Vector3((a.x + b.x) * 0.5, 0.0, (a.z + b.z) * 0.5).normalized()
			var normal: Vector3 = (outward + Vector3.UP * (-1.0 if ring == 0 else 1.0)).normalized() if ring != 1 else outward
			_quad(st, a, b, c, d, normal)
	for i in inner.size():
		var j: int = (i + 1) % inner.size()
		_triangle(st, Vector3(0.0, height, 0.0), Vector3(inner[i].x, height, inner[i].y), Vector3(inner[j].x, height, inner[j].y), Vector3.UP)
		_triangle(st, Vector3.ZERO, Vector3(inner[j].x, 0.0, inner[j].y), Vector3(inner[i].x, 0.0, inner[i].y), Vector3.DOWN)
	var mesh: ArrayMesh = st.commit()
	_meshes[key] = mesh
	return mesh


static func _build_rail_meshes(straight: bool, key: String) -> void:
	var rails := SurfaceTool.new()
	var ties := SurfaceTool.new()
	rails.begin(Mesh.PRIMITIVE_TRIANGLES)
	ties.begin(Mesh.PRIMITIVE_TRIANGLES)
	for offset: float in [-0.092, 0.092]:
		var points := PackedVector3Array()
		if straight:
			points.append(Vector3(offset, 0.175, -0.5))
			points.append(Vector3(offset, 0.175, 0.5))
		else:
			for i in 17:
				var angle: float = PI - float(i) / 16.0 * PI * 0.5
				var radius: float = 0.5 + offset
				points.append(Vector3(0.5 + cos(angle) * radius, 0.175, -0.5 + sin(angle) * radius))
		_tube(rails, points, 0.026, 0.030)
	for i in 8:
		var t: float = (float(i) + 0.5) / 8.0
		var position: Vector3
		var angle: float
		if straight:
			position = Vector3(0.0, 0.137, lerpf(-0.5, 0.5, t))
			angle = 0.0
		else:
			var arc: float = PI - t * PI * 0.5
			position = Vector3(0.5 + cos(arc) * 0.5, 0.137, -0.5 + sin(arc) * 0.5)
			angle = -arc
		_append_box(ties, Vector3(0.31, 0.035, 0.052), Transform3D(Basis(Vector3.UP, angle), position))
	_meshes[key + "_rails"] = rails.commit()
	_meshes[key + "_sleepers"] = ties.commit()


static func _tube(st: SurfaceTool, points: PackedVector3Array, radius: float, vertical_radius: float) -> void:
	for segment in points.size() - 1:
		var tangent: Vector3 = (points[segment + 1] - points[segment]).normalized()
		var side: Vector3 = tangent.cross(Vector3.UP).normalized()
		for j in 8:
			var p: float = TAU * float(j) / 8.0
			var q: float = TAU * float(j + 1) / 8.0
			var delta_p: Vector3 = side * cos(p) * radius + Vector3.UP * sin(p) * vertical_radius
			var delta_q: Vector3 = side * cos(q) * radius + Vector3.UP * sin(q) * vertical_radius
			var normal: Vector3 = (side * cos((p + q) * 0.5) + Vector3.UP * sin((p + q) * 0.5)).normalized()
			_quad(st, points[segment] + delta_p, points[segment + 1] + delta_p, points[segment + 1] + delta_q, points[segment] + delta_q, normal)


static func _append_box(st: SurfaceTool, size: Vector3, transform: Transform3D) -> void:
	var h: Vector3 = size * 0.5
	var corners: Array[Vector3] = [Vector3(-h.x, -h.y, -h.z), Vector3(h.x, -h.y, -h.z), Vector3(h.x, -h.y, h.z), Vector3(-h.x, -h.y, h.z), Vector3(-h.x, h.y, -h.z), Vector3(h.x, h.y, -h.z), Vector3(h.x, h.y, h.z), Vector3(-h.x, h.y, h.z)]
	var faces: Array[Array] = [[4, 5, 6, 7, Vector3.UP], [3, 2, 1, 0, Vector3.DOWN], [0, 1, 5, 4, Vector3.FORWARD], [2, 3, 7, 6, Vector3.BACK], [1, 2, 6, 5, Vector3.RIGHT], [3, 0, 4, 7, Vector3.LEFT]]
	for face: Array in faces:
		_quad(st, transform * corners[face[0]], transform * corners[face[1]], transform * corners[face[2]], transform * corners[face[3]], transform.basis * (face[4] as Vector3))


static func _roof_mesh() -> ArrayMesh:
	if _meshes.has("folded_roof"):
		return _meshes["folded_roof"]
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	var a := Vector3(-0.36, 0.0, -0.39)
	var b := Vector3(0.36, 0.0, -0.39)
	var c := Vector3(0.36, 0.255, 0.0)
	var d := Vector3(-0.36, 0.255, 0.0)
	st.set_color(Color.WHITE)
	_quad(st, a, b, c, d, Vector3(0.0, 0.84, -0.55))
	st.set_color(Color(0.87, 0.92, 1.0))
	_quad(st, d, c, Vector3(0.36, 0.0, 0.39), Vector3(-0.36, 0.0, 0.39), Vector3(0.0, 0.84, 0.55))
	st.set_color(Color(0.97, 0.97, 0.97))
	_triangle(st, Vector3(0.36, 0.0, -0.39), Vector3(0.36, 0.255, 0.0), Vector3(0.36, 0.0, 0.39), Vector3.RIGHT)
	_triangle(st, Vector3(-0.36, 0.0, 0.39), Vector3(-0.36, 0.255, 0.0), Vector3(-0.36, 0.0, -0.39), Vector3.LEFT)
	_meshes["folded_roof"] = st.commit()
	return _meshes["folded_roof"]


static func _triangle_mesh(width: float, depth: float, height: float) -> ArrayMesh:
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	_triangle(st, Vector3(-width * 0.5, height, depth * 0.5), Vector3(0.0, height, -depth * 0.5), Vector3(width * 0.5, height, depth * 0.5), Vector3.UP)
	return st.commit()


static func _quad(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, d: Vector3, normal: Vector3) -> void:
	_triangle(st, a, b, c, normal)
	_triangle(st, a, c, d, normal)


static func _triangle(st: SurfaceTool, a: Vector3, b: Vector3, c: Vector3, normal: Vector3) -> void:
	for vertex: Vector3 in [a, b, c]:
		st.set_normal(normal)
		var uv: Vector2
		if absf(normal.y) > 0.5:
			uv = Vector2(vertex.x + 0.5, vertex.z + 0.5)
		elif absf(normal.x) > 0.5:
			uv = Vector2(vertex.z + 0.5, vertex.y)
		else:
			uv = Vector2(vertex.x + 0.5, vertex.y)
		st.set_uv(uv)
		st.add_vertex(vertex)
