extends SceneTree
## Same real input sequence and capture dimensions for baseline and replacement UI.

var screen: ArchipelScreen
var destination: String
var scene_path: String = "res://experiments/littoral/composition.tscn"
var observations: Array[Dictionary] = []


func _initialize() -> void:
	for argument: String in OS.get_cmdline_user_args():
		if argument.begins_with("--qa-out="): destination = argument.trim_prefix("--qa-out=")
		elif argument.begins_with("--qa-scene="): scene_path = argument.trim_prefix("--qa-scene=")
	call_deferred("run")


func click(point: Vector2) -> void:
	var event := InputEventMouseButton.new()
	event.button_index = MOUSE_BUTTON_LEFT
	event.pressed = true
	event.position = point * Vector2(root.size) / screen.get_viewport_rect().size
	Input.parse_input_event(event)
	var up := event.duplicate() as InputEventMouseButton
	up.pressed = false
	Input.parse_input_event(up)
	await create_timer(0.24).timeout


func hover(point: Vector2) -> void:
	var event := InputEventMouseMotion.new()
	event.position = point * Vector2(root.size) / screen.get_viewport_rect().size
	event.global_position = event.position
	Input.parse_input_event(event)
	await create_timer(1.0).timeout


func shot(id: String) -> void:
	await RenderingServer.frame_post_draw
	var error: Error = root.get_texture().get_image().save_png(destination.path_join(id + ".png"))
	if error != OK: push_error("QA_CAPTURE_FAILED " + id)
	var tooltip_nodes: Array[Dictionary] = []
	find_tooltips(root, tooltip_nodes)
	observations.append({"id": id, "phase": screen.get_phase(), "rotations": screen._board.rotations,
		"attempts": screen._board.attempts, "window": [root.size.x, root.size.y],
		"tooltip_text": screen._view.tooltip_text, "tooltip_nodes": tooltip_nodes,
		"ready": bool(screen._board.evaluate().get("success", false)),
		"pause_rect": str(screen._pause_panel.get_global_rect()), "pause_min": str(screen._pause_panel.get_combined_minimum_size()),
		"pause_parent_rect": str((screen._pause_panel.get_parent() as Control).get_global_rect()),
		"pause_note_min": str(screen._pause_note.get_combined_minimum_size())})
	print("UIUX_CAPTURE " + JSON.stringify(observations[-1]))


func find_tooltips(node: Node, result: Array[Dictionary]) -> void:
	if "tooltip" in str(node.name).to_lower():
		result.append({"name": str(node.name), "class": node.get_class(), "visible": node.get("visible")})
	for child: Node in node.get_children(true): find_tooltips(child, result)


func run() -> void:
	DirAccess.make_dir_recursive_absolute(destination)
	screen = load(scene_path).instantiate() as ArchipelScreen
	for argument: String in OS.get_cmdline_user_args():
		if argument.begins_with("--qa-text-scale="): screen.set("text_scale", float(argument.trim_prefix("--qa-text-scale=")))
	root.add_child(screen)
	if OS.get_cmdline_user_args().has("--qa-no-shadows"):
		for light: Node in screen._view._world.find_children("*", "DirectionalLight3D", true, false):
			(light as DirectionalLight3D).shadow_enabled = false
	if OS.get_cmdline_user_args().has("--qa-grayscale"):
		var layer := CanvasLayer.new()
		layer.layer = 100
		var gray := ColorRect.new()
		gray.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		gray.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var material := ShaderMaterial.new()
		material.shader = load("res://tools/qa_grayscale.gdshader") as Shader
		gray.material = material
		layer.add_child(gray)
		root.add_child(layer)
	if OS.get_cmdline_user_args().has("--qa-disable-tooltip"): screen._view.tooltip_text = ""
	await process_frame
	await process_frame
	screen.restart_level()
	await create_timer(0.4).timeout
	await shot("01-preparation")
	await click(screen._view.index_to_canvas_center(8))
	await hover(screen._view.index_to_canvas_center(8) + Vector2(2, 2))
	await shot("02-rotation-hover")
	await click(screen._view.index_to_canvas_center(16))
	await hover(screen._view.index_to_canvas_center(16) + Vector2(2, 2))
	await shot("03-rotation-two")
	await click(screen._buttons["undo"].get_global_rect().get_center())
	await click(screen._buttons["undo"].get_global_rect().get_center())
	for command: Dictionary in screen._board.level.solution_commands:
		for turn in int(command["quarter_turns"]): await click(screen._view.index_to_canvas_center(int(command["index"])))
	await hover(screen._buttons["dispatch"].get_global_rect().get_center())
	await shot("04-ready")
	await click(screen._buttons["dispatch"].get_global_rect().get_center())
	await create_timer(0.4).timeout
	await shot("05-transport")
	await create_timer(3.0).timeout
	await shot("06-won")
	await click(screen._buttons["pause"].get_global_rect().get_center())
	await shot("07-paused-won")
	if OS.get_cmdline_user_args().has("--qa-full-path"):
		await click(screen._buttons["resume"].get_global_rect().get_center())
		await click(screen._buttons["dispatch"].get_global_rect().get_center())
		await click(screen._buttons["hint"].get_global_rect().get_center())
		await click(screen._buttons["dispatch"].get_global_rect().get_center())
		await create_timer(3).timeout
		await shot("08-error-after-hint")
		await click(screen._buttons["pause"].get_global_rect().get_center())
		await click(screen._buttons["restart"].get_global_rect().get_center())
		await click(screen._view.index_to_canvas_center(8))
		await click(screen._buttons["pause"].get_global_rect().get_center())
		await shot("09-paused-preparation")
		await click(screen._buttons["resume"].get_global_rect().get_center())
		await click(screen._buttons["undo"].get_global_rect().get_center())
		await shot("10-replayed")
	var file := FileAccess.open(destination.path_join("states.json"), FileAccess.WRITE)
	file.store_string(JSON.stringify({"scene": scene_path, "states": observations}, "\t") + "\n")
	file.close()
	var expected: bool = observations.size() == 10 and screen._phase == "planning" if OS.get_cmdline_user_args().has("--qa-full-path") else observations.size() == 7 and screen._phase == "won"
	quit(0 if expected else 1)
