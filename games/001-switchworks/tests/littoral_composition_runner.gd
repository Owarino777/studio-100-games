extends SceneTree
## Contracts on imported modular assets, real projection and inherited state machine.

var passed: int = 0
var failed: int = 0
const SCENE = preload("res://experiments/littoral/composition.tscn")


func _initialize() -> void:
	call_deferred("run")


func check(value: bool, label: String) -> void:
	if value: passed += 1
	else:
		failed += 1
		push_error("LITTORAL_FAIL " + label)


func run() -> void:
	for resolution: Vector2i in [Vector2i(390, 844), Vector2i(360, 640), Vector2i(800, 1067)]:
		var viewport := SubViewport.new()
		viewport.size = resolution
		root.add_child(viewport)
		var screen: ArchipelScreen = SCENE.instantiate()
		viewport.add_child(screen)
		await process_frame
		await process_frame
		var view := screen._view as LittoralBoardView
		check(view != null, "isolated view installed")
		check(view._viewport.get_camera_3d() == view._camera and view._camera.current, "camera is current in actual 3D subviewport")
		check(view._world.find_children("*", "WorldEnvironment", true, false).size() == 1, "one actual environment")
		check(view._world.find_children("*", "DirectionalLight3D", true, false).size() == 2, "key and fill exist at runtime")
		check(screen._board.level.id == "archipel-double-flux-01", "same level")
		check(view._pieces.size() == 36, "36 real tiles")
		var marker_mesh := view._selection.get_child(0) as MeshInstance3D
		check(absf(marker_mesh.position.y + 0.145) < 0.001, "selection cancels authored local height")
		check(view._tile_batches.size() == 3, "three imported tile surfaces")
		for batch: MultiMeshInstance3D in view._tile_batches:
			check(batch.multimesh.instance_count == 36, "36 tile instances per surface")
		for index in 36:
			var point: Vector2 = view.index_to_canvas_center(index) - view.global_position
			check(view.cell_at_canvas_point(point) == index, "projection picks cell %d at %s" % [index, resolution])
		for key: String in ["pause", "undo", "dispatch", "hint"]:
			var rect: Rect2 = screen._buttons[key].get_global_rect()
			check(Rect2(Vector2.ZERO, Vector2(resolution)).encloses(rect), "button inside " + key)
			check(rect.size.x >= 48 and rect.size.y >= 48, "48-unit action " + key)
		check(not screen._status.get_global_rect().intersects(screen._buttons["dispatch"].get_global_rect()), "guidance clear of primary action")
		check(not screen._stats_panel.get_global_rect().intersects(screen._status.get_global_rect()), "stats clear of guidance")
		check(not screen.rotate_cell(screen._board.level.source_indices["A"]), "source fixed")
		check(not screen.rotate_cell(screen._board.level.destination_indices["B"]), "destination fixed")
		screen.set_reduced_motion(true)
		var original: PackedInt32Array = screen._board.ports
		for index in 36:
			if not screen._board.can_rotate(index): continue
			for turn in 4:
				check(screen.rotate_cell(index), "quarter turn accepted")
				var rendered: Node3D = view._rails[index]
				var mask: int = 0
				for port: Node in rendered.get_children():
					if not port.name.begins_with("Port"): continue
					var local: Vector3 = rendered.transform * (port as Node3D).position - rendered.position
					check(absf(maxf(absf(local.x), absf(local.z)) - 0.5) < 0.001, "port on exact cell boundary")
					check(absf(local.y - 0.175) < 0.001, "uniform port height")
					mask |= PostalBoardView._direction_mask(Vector3(local.x, 0, local.z).normalized())
				check(mask == screen._board.ports[index], "visible ports equal logical mask")
			check(screen._board.ports[index] == original[index], "four turns identity")
		screen.restart_level()
		screen.dispatch()
		screen._process(10)
		check(screen.get_phase() == "failed", "initial route fails honestly")
		screen.restart_level()
		for command: Dictionary in screen._board.level.solution_commands:
			for turn in int(command["quarter_turns"]): screen.rotate_cell(int(command["index"]))
		check(screen._board.ports == screen._board.level.solution_ports, "existing witness")
		screen.set_reduced_motion(false)
		screen.dispatch()
		screen._process(0.2)
		screen.pause_game()
		var position: Vector3 = view._parcels["A"].position
		screen._process(1.0)
		check(view._parcels["A"].position == position, "pause freezes presentation")
		screen.resume_game()
		screen._process(10)
		await create_timer(0.6).timeout
		check(screen.get_phase() == "won", "representative level completes")
		for label: String in ["A", "B"]:
			var state: Dictionary = view.get_reception_state(label)
			check(state["received"] and state["seal_visible"] and not state["parcel_visible"], "event-driven receipt " + label)
			check((state["lid_rotation"] as Vector3).length() < 0.001, "lid closed " + label)
		screen.restart_level()
		screen.set_reduced_motion(true)
		for command: Dictionary in screen._board.level.solution_commands:
			for turn in int(command["quarter_turns"]): screen.rotate_cell(int(command["index"]))
		screen.dispatch()
		screen._process(0.001)
		check(screen.get_phase() == "won", "reduced motion still completes")
		check(not screen.rotate_cell(8), "winning state rejects edits")
		viewport.queue_free()
		await process_frame
		await process_frame
	if OS.get_cmdline_user_args().has("--negative-control"): check(false, "intentional negative control")
	print("LITTORAL_TESTS passed=%d failed=%d" % [passed, failed])
	quit(1 if failed else 0)
