extends Node3D
## Native asset-family inspection; no gameplay implementation.

const ART := preload("res://scripts/visuals/postal_art_factory.gd")
const RAILS: Array[Array] = [
	[0, 0, 0, 0, 0, 0],
	[10, 10, 12, 0, 6, 10],
	[0, 0, 3, 10, 9, 0],
	[0, 6, 10, 12, 0, 0],
	[10, 9, 0, 3, 10, 10],
	[0, 0, 0, 0, 0, 0],
]


func _ready() -> void:
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = Color("#bedde8")
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color("#e7eee9")
	environment.ambient_light_energy = 0.30
	environment.tonemap_mode = Environment.TONE_MAPPER_LINEAR
	var world := WorldEnvironment.new()
	world.environment = environment
	add_child(world)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-58.0, -32.0, 0.0)
	sun.light_energy = 0.65
	sun.light_color = Color("#fff0d9")
	sun.shadow_enabled = true
	add_child(sun)
	var camera := Camera3D.new()
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.keep_aspect = Camera3D.KEEP_WIDTH
	camera.size = 8.0
	camera.position = Vector3(0.0, 10.0, 5.7)
	add_child(camera)
	camera.look_at(Vector3.ZERO)
	camera.current = true
	add_child(ART.create_island())
	for row in 6:
		for column in 6:
			var at := Vector3(float(column) - 2.5, 0.0, float(row) - 2.5)
			var tile: Node3D = ART.create_tile()
			tile.position = at
			add_child(tile)
			if (row == 1 or row == 4) and (column == 0 or column == 5):
				var label: String = "A" if row == 1 else "B"
				var color: Color = ART.BLUE if row == 1 else ART.CORAL
				var station: Node3D = ART.create_station(label, column == 0, color)
				station.position = at
				add_child(station)
				if column == 0:
					var parcel: Node3D = ART.create_parcel(label, color)
					parcel.position = at + Vector3(0.30, 0.22, 0.0)
					add_child(parcel)
			elif int(RAILS[row][column]) != 0:
				var rail: Node3D = ART.create_rail(int(RAILS[row][column]), ART.BLUE if row < 3 else ART.CORAL)
				rail.position = at
				add_child(rail)
	for side: float in [-1.0, 1.0]:
		var flower: Node3D = ART.create_flower()
		flower.position = Vector3(side * 3.55, -0.20, 2.7)
		add_child(flower)
	print("ART_SHOWCASE_READY renderer=%s" % RenderingServer.get_current_rendering_method())
