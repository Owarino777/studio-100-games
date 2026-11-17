extends SceneTree
## Independent UI contracts against actual nodes, unchanged model and imported meshes.

const GAME = preload("res://experiments/postal_workshop/game.tscn")
var passed: int = 0
var failed: int = 0


func _initialize() -> void:
	call_deferred("run")


func check(value: bool, message: String) -> void:
	if value: passed += 1
	else:
		failed += 1
		push_error("POSTAL_UI_FAIL " + message)


func rect_checks(screen: PostalWorkshopScreen, size: Vector2i, phase: String) -> void:
	var bounds := Rect2(Vector2.ZERO, Vector2(size)).grow(1)
	var ui: Dictionary = screen.get_ui_controls()
	for key: String in ["pause", "dispatch", "undo", "hint", "guidance", "header", "stats", "victory"]:
		var control: Control = screen._buttons["dispatch"] if key == "dispatch" else (screen._buttons[key] if key in ["pause", "undo", "hint"] else ui[key])
		if not control.is_visible_in_tree(): continue
		check(bounds.encloses(control.get_global_rect()), "%s %s inside %s" % [phase, key, size])
		if control is Button:
			check(control.size.x >= 48 and control.size.y >= 48, phase + " tactile " + key)
			check(not control.get_global_rect().intersects(screen._view.get_global_rect()), phase + " action clear of board " + key)
	if screen._status.visible:
		check(not screen._status.get_global_rect().intersects(screen._view.get_global_rect()), phase + " guidance never on rails")
		check(screen._status.get_visible_line_count() >= screen._status.get_line_count(), phase + " all guidance lines visible")
	for label: Node in screen._hud.find_children("*", "Label", true, false):
		var text := label as Label
		if not text.is_visible_in_tree(): continue
		check(text.size.y + 1 >= text.get_line_count() * text.get_line_height(), phase + " label not vertically clipped " + str(text.get_path()))
	check(screen._view.tooltip_text.is_empty(), phase + " no native board tooltip")
	check(not screen._victory.visible or not screen._paused, phase + " no result/pause double layer")


func settle() -> void:
	await process_frame
	await process_frame
	await process_frame


func run() -> void:
	var profiles: Array[Dictionary] = [
		{"size": Vector2i(360,640), "scale": 1.0}, {"size": Vector2i(390,844), "scale": 1.0},
		{"size": Vector2i(430,932), "scale": 1.0}, {"size": Vector2i(844,390), "scale": 1.0},
		{"size": Vector2i(800,1067), "scale": 1.0}, {"size": Vector2i(320,568), "scale": 1.0},
		{"size": Vector2i(360,640), "scale": 1.25}, {"size": Vector2i(430,932), "scale": 1.5}]
	for profile: Dictionary in profiles:
		var viewport := SubViewport.new()
		var size: Vector2i = profile["size"]
		viewport.size = size
		root.add_child(viewport)
		var screen := GAME.instantiate() as PostalWorkshopScreen
		screen.text_scale = profile["scale"]
		viewport.add_child(screen)
		await settle()
		check(screen._pause_note.get_combined_minimum_size().y < size.y * 0.5, "hidden pause text already shaped at useful width")
		check(screen._board.level.id == "archipel-double-flux-01", "same level")
		check(not screen._board.evaluate()["success"], "initial route not solved")
		rect_checks(screen, size, "preparation")
		for index in 36:
			var point: Vector2 = screen._view.index_to_canvas_center(index) - screen._view.global_position
			check(screen._view.cell_at_canvas_point(point) == index, "actual projection index %d" % index)
		var initial: Dictionary = screen._board.snapshot()
		check(screen.rotate_cell(8), "rotate existing case")
		check(screen._buttons["dispatch"].disabled, "rotation atomically shows primary unavailable")
		await create_timer(0.23).timeout
		check(not screen._buttons["dispatch"].disabled, "primary unlocked when rotation settles")
		check(screen.undo_move(), "undo accepted")
		check(screen._board.snapshot() == initial, "undo exact model snapshot")
		var ports: PackedInt32Array = screen._board.ports
		screen.request_hint()
		check(screen._board.ports == ports and screen._board.hints == 1, "hint preserves ports, increments existing counter")
		screen.dispatch()
		screen._process(10)
		check(screen._phase == "failed", "authentic error, not fabricated success")
		await settle()
		rect_checks(screen, size, "failed")
		screen.restart_level()
		screen.set_reduced_motion(true)
		for command: Dictionary in screen._board.level.solution_commands:
			for turn in int(command["quarter_turns"]): screen.rotate_cell(int(command["index"]))
		check(screen.get_presentation_state()["ready"], "whole existing circuit ready")
		check(screen._board.attempts == 0, "preview doesn't count an attempt")
		await settle()
		rect_checks(screen, size, "ready")
		var legacy: Dictionary = screen._board.snapshot()
		legacy["ports"] = Array(legacy["ports"])
		screen.set_reduced_motion(false)
		screen.dispatch()
		screen._process(0.2)
		screen.pause_game()
		await settle()
		check(screen._pause_panel.is_visible_in_tree() and screen._pause_cover.visible, "pause is sole modal")
		check(screen._buttons["dispatch"].focus_mode == Control.FOCUS_NONE, "background focus disabled")
		check(bounds_for(size).encloses(screen._pause_panel.get_global_rect()), "pause inside screen")
		var position: Vector3 = screen._view._parcels["A"].position
		screen._process(1)
		check(screen._view._parcels["A"].position == position, "pause freezes transport")
		screen.resume_game()
		screen._process(10)
		check(screen._phase == "won", "logical result preserved immediately")
		check(not screen._victory.visible, "summary waits for visible receipt completion")
		check(not screen._buttons["dispatch"].disabled and screen._buttons["dispatch"].text == "Rejouer", "replay remains available, no artificial logic delay")
		await create_timer(0.6).timeout
		await settle()
		check(screen._victory.visible, "inline result after real receipts")
		for address: String in ["A", "B"]:
			var received: Dictionary = screen._view.get_reception_state(address)
			check(received["received"] and received["seal_visible"] and not received["parcel_visible"], "local accepted state " + address)
		rect_checks(screen, size, "won")
		screen.pause_game()
		await settle()
		check(not screen._victory.visible and screen._pause_heading.text == "Tournée terminée", "paused victory has one coherent layer")
		check(bounds_for(size).encloses(screen._pause_panel.get_global_rect()), "paused victory inside screen")
		screen.resume_game()
		screen._primary_action()
		check(screen._phase == "planning" and screen._board.rotations == 0, "same primary control replays")
		check(screen.restore_preparation(legacy), "legacy snapshot schema restored")
		check(screen._board.ports == PackedInt32Array(legacy["ports"]) and screen._board.attempts == legacy["attempts"], "restore exact fields")
		screen.set_reduced_motion(true)
		screen.dispatch()
		screen._process(0.001)
		check(screen._phase == "won" and screen._receipts_complete, "reduced motion explicit and immediate")
		print("POSTAL_UI_PROFILE size=%s text_scale=%s" % [size, profile["scale"]])
		viewport.queue_free()
		await settle()
	if OS.get_cmdline_user_args().has("--negative-control"): check(false, "intentional negative control")
	print("POSTAL_UI_TESTS passed=%d failed=%d" % [passed, failed])
	quit(1 if failed else 0)


func bounds_for(size: Vector2i) -> Rect2:
	return Rect2(Vector2.ZERO, Vector2(size)).grow(1)
