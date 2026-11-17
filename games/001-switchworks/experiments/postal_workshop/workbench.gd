extends Control
## Four-family limited native bench. Controls mutate the existing PostalBoard.
## This diagnostic composition is explicitly not a new puzzle level.

var board: PostalBoard
var rails: Array[Node3D] = []
var receivers: Array[Node3D] = []
var state_label: Label
var _viewport: SubViewport
var _output: String


func _ready() -> void:
	get_window().content_scale_size = Vector2i(960, 800)
	theme = WorkshopTheme.make()
	board = PostalBoard.new(PostalLevel.load_default())
	var background := ColorRect.new()
	background.color = WorkshopTheme.TOKENS.background
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(background)
	var stack := VBoxContainer.new()
	stack.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	stack.offset_left = 24
	stack.offset_top = 20
	stack.offset_right = -24
	stack.offset_bottom = -20
	stack.add_theme_constant_override("separation", 12)
	add_child(stack)
	var title := Label.new()
	title.text = "COMPTOIR MARITIME / BANC LIMITÉ"
	title.theme_type_variation = "Objective"
	stack.add_child(title)
	var note := Label.new()
	note.text = "AVANT à gauche / CANDIDAT à droite · Même caméra et lumière · Pas un nouveau niveau"
	note.theme_type_variation = "Caption"
	stack.add_child(note)
	var container := SubViewportContainer.new()
	container.stretch = true
	container.size_flags_vertical = Control.SIZE_EXPAND_FILL
	stack.add_child(container)
	_viewport = SubViewport.new()
	_viewport.size = Vector2i(912, 540)
	_viewport.msaa_3d = Viewport.MSAA_4X
	container.add_child(_viewport)
	var world := Node3D.new()
	_viewport.add_child(world)
	var environment := WorldEnvironment.new()
	environment.environment = Environment.new()
	environment.environment.background_mode = Environment.BG_COLOR
	environment.environment.background_color = WorkshopTheme.TOKENS.background
	environment.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.environment.ambient_light_color = Color("dce5e3")
	environment.environment.ambient_light_energy = 0.26
	world.add_child(environment)
	var sky := Sky.new()
	var sky_material := ProceduralSkyMaterial.new()
	sky_material.sky_top_color = Color("8babb4")
	sky_material.sky_horizon_color = Color("e9e6d6")
	sky_material.ground_bottom_color = Color("77827b")
	sky_material.energy_multiplier = 0.6
	sky.sky_material = sky_material
	sky.radiance_size = Sky.RADIANCE_SIZE_128
	environment.environment.sky = sky
	environment.environment.reflected_light_source = Environment.REFLECTION_SOURCE_SKY
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-57, -30, 0)
	sun.light_energy = 0.56
	sun.shadow_enabled = true
	sun.shadow_opacity = 0.24
	sun.shadow_normal_bias = 0.65
	sun.directional_shadow_mode = DirectionalLight3D.SHADOW_ORTHOGONAL
	sun.directional_shadow_max_distance = 20
	world.add_child(sun)
	var camera := Camera3D.new()
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.keep_aspect = Camera3D.KEEP_WIDTH
	camera.size = 8.2
	camera.position = Vector3(0, 8, 7)
	world.add_child(camera)
	camera.look_at(Vector3(0, 0.24, 0))
	camera.current = true
	for side in 2:
		for row in 3:
			var at := Vector3(-2.1 if side == 0 else 2.1, 0, float(row - 1) * 1.75)
			var tile: Node3D = instance("tuile", side)
			tile.position = at
			tile.scale = Vector3.ONE * 1.45
			world.add_child(tile)
			var id: String = ["guichet_a", "voie_coude", "boite_b"][row]
			var model: Node3D = instance(id, side)
			model.position = at
			model.scale = Vector3.ONE * 1.45
			world.add_child(model)
			if row == 2:
				receivers.append(model)
				(model.get_node("ReceiptSeal") as Node3D).hide()
			elif row == 1: rails.append(model)
	var actions := HBoxContainer.new()
	actions.add_theme_constant_override("separation", 12)
	stack.add_child(actions)
	for pair: Array in [["Tourner", rotate], ["Annuler", undo], ["Réception vérifiée", receive]]:
		var button := Button.new()
		button.text = pair[0]
		button.theme_type_variation = "Primary" if pair[0] == "Tourner" else "Quiet"
		button.custom_minimum_size.y = 52
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(pair[1])
		actions.add_child(button)
	state_label = Label.new()
	state_label.text = "Modèle réel : quart de tour de la case 8 ; aucun score ou niveau créé."
	state_label.theme_type_variation = "Caption"
	stack.add_child(state_label)
	for argument: String in OS.get_cmdline_user_args():
		if argument.begins_with("--bench-out="): _output = argument.trim_prefix("--bench-out=")
	if not _output.is_empty(): call_deferred("capture_bench")


func instance(id: String, side: int) -> Node3D:
	var prefix: String = "res://assets/littoral-study/models/" if side == 0 else "res://assets/postal-workshop/models/"
	var model: Node3D = (load(prefix + id + ".glb") as PackedScene).instantiate() as Node3D
	if side == 1: WorkshopModels.color_tracks(model, "B" if id.ends_with("_b") else "A")
	return model


func rotate() -> void:
	if not board.rotate(8): return
	for rail: Node3D in rails:
		var tween := create_tween()
		tween.tween_property(rail, "rotation:y", rail.rotation.y - PI * 0.5, 0.16).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	state_label.text = "Case 8 · %d rotation(s) · ports réels %d" % [board.rotations, board.ports[8]]


func undo() -> void:
	if not board.undo(): return
	for rail: Node3D in rails: rail.rotation.y += PI * 0.5
	state_label.text = "Annulation du modèle : compte et ports restaurés."


func receive() -> void:
	var witness := PostalBoard.new(PostalLevel.load_default())
	for command: Dictionary in witness.level.solution_commands:
		for i in int(command["quarter_turns"]): witness.rotate(int(command["index"]))
	var result: Dictionary = witness.simulate()
	if not bool(result["success"]): return
	for receiver: Node3D in receivers:
		var lid := receiver.get_node("ReceptionLid") as Node3D
		var seal := receiver.get_node("ReceiptSeal") as Node3D
		seal.hide()
		var tween := create_tween()
		tween.tween_property(lid, "rotation:z", 0.75, 0.14)
		tween.tween_property(lid, "rotation:z", 0.0, 0.18)
		tween.tween_callback(seal.show)
	state_label.text = "Deux livraisons vérifiées par le modèle existant ; aperçu de la réception."


func capture_bench() -> void:
	DirAccess.make_dir_recursive_absolute(_output)
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	root_capture("rest")
	rotate()
	await get_tree().create_timer(0.24).timeout
	root_capture("rotated")
	receive()
	await get_tree().create_timer(0.5).timeout
	root_capture("received")
	print("WORKSHOP_BENCH model_rotation=%d topology=existing_6x6" % board.rotations)
	get_tree().quit()


func root_capture(id: String) -> void:
	get_viewport().get_texture().get_image().save_png(_output.path_join(id + ".png"))
