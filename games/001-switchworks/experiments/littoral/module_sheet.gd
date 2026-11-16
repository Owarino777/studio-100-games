extends Control
## Authentic in-engine modular inspection, separate from the playable composition.

const ART = preload("res://experiments/littoral/littoral_models.gd")


func _ready() -> void:
	get_window().content_scale_size = Vector2i(960, 720)
	var backdrop := ColorRect.new()
	backdrop.color = Color("e9e1d1")
	backdrop.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(backdrop)
	var heading := Label.new()
	heading.text = "ARCHIPEL POSTAL / CÉRAMIQUE LITTORALE"
	heading.position = Vector2(32, 18)
	heading.add_theme_font_override("font", PostalTheme.font(850))
	heading.add_theme_font_size_override("font_size", 26)
	heading.add_theme_color_override("font_color", ART.INK)
	add_child(heading)
	var note := Label.new()
	note.text = "MODÈLES GODOT EXÉCUTÉS · sources TSCN / échanges GLB · 16.11.2026"
	note.position = Vector2(32, 58)
	note.add_theme_font_override("font", PostalTheme.font(650))
	note.add_theme_color_override("font_color", ART.INK)
	add_child(note)
	var container := SubViewportContainer.new()
	container.position = Vector2(0, 100)
	container.size = Vector2(960, 540)
	container.stretch = true
	add_child(container)
	var viewport := SubViewport.new()
	viewport.size = Vector2i(960, 540)
	viewport.msaa_3d = Viewport.MSAA_4X
	container.add_child(viewport)
	var world := Node3D.new()
	viewport.add_child(world)
	var env := WorldEnvironment.new()
	env.environment = Environment.new()
	env.environment.background_mode = Environment.BG_COLOR
	env.environment.background_color = Color("e9e1d1")
	env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	env.environment.ambient_light_color = Color("e5eced")
	env.environment.ambient_light_energy = 0.24
	var sky_material := ProceduralSkyMaterial.new()
	sky_material.sky_top_color = Color("8faebc")
	sky_material.sky_horizon_color = Color("eee7d6")
	sky_material.ground_horizon_color = Color("d1d9cc")
	sky_material.ground_bottom_color = Color("687d7b")
	sky_material.energy_multiplier = 0.65
	var sky := Sky.new()
	sky.radiance_size = Sky.RADIANCE_SIZE_128
	sky.sky_material = sky_material
	env.environment.sky = sky
	env.environment.reflected_light_source = Environment.REFLECTION_SOURCE_SKY
	world.add_child(env)
	var sun := DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-55, -28, 0)
	sun.light_energy = 0.62
	sun.light_color = Color("fff4dc")
	sun.shadow_enabled = true
	sun.shadow_opacity = 0.28
	sun.directional_shadow_mode = DirectionalLight3D.SHADOW_ORTHOGONAL
	sun.directional_shadow_max_distance = 30
	world.add_child(sun)
	var camera := Camera3D.new()
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.keep_aspect = Camera3D.KEEP_WIDTH
	camera.size = 9.9
	camera.position = Vector3(0, 9, 10)
	world.add_child(camera)
	camera.look_at(Vector3(0, 0.4, 0))
	camera.current = true
	var ids: Array[String] = ["guichet_a", "boite_a", "voie_coude", "guichet_b", "boite_b", "voie_droite"]
	for i in ids.size():
		var at := Vector3(float(i % 3 - 1) * 3.1, 0, -1.5 if i < 3 else 1.5)
		var tile: Node3D = LittoralBoardView.model("tuile")
		tile.scale = Vector3.ONE * 2.15
		tile.position = at
		world.add_child(tile)
		var model: Node3D = LittoralBoardView.model(ids[i])
		model.scale = Vector3.ONE * 2.15
		model.position = at
		world.add_child(model)
		if i == 1 or i == 4:
			var seal := model.get_node_or_null("ReceiptSeal") as Node3D
			if seal != null: seal.hide()
		if i == 0 or i == 3:
			var parcel: Node3D = LittoralBoardView.model("colis_a" if i == 0 else "colis_b")
			parcel.scale = Vector3.ONE * 2.15
			parcel.position = at + Vector3(0.60, 0.50, 0)
			world.add_child(parcel)
	for i in 3:
		var caption := Label.new()
		caption.text = ["GUICHET · sortie est", "BOÎTE · entrée ouest", "VOIE · deux ports exacts"][i]
		caption.position = Vector2(float(i) * 310 + 40, 648)
		caption.add_theme_font_override("font", PostalTheme.font(800))
		caption.add_theme_font_size_override("font_size", 18)
		caption.add_theme_color_override("font_color", ART.INK)
		add_child(caption)
	var footer := Label.new()
	footer.text = "A = cercle bleu / B = triangle terre cuite · Camera et lumière communes · Aucune planche conceptuelle utilisée comme texture"
	footer.position = Vector2(32, 686)
	footer.add_theme_font_override("font", PostalTheme.font(600))
	footer.add_theme_font_size_override("font_size", 13)
	footer.add_theme_color_override("font_color", ART.INK)
	add_child(footer)
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	for argument: String in OS.get_cmdline_user_args():
		if argument.begins_with("--sheet-shot="):
			var path: String = argument.trim_prefix("--sheet-shot=")
			var error: Error = get_viewport().get_texture().get_image().save_png(path)
			print("LITTORAL_SHEET result=%d" % error)
			get_tree().quit(0 if error == OK else 1)
