extends SceneTree
## Integration checks for the technical bootstrap screen and its input signal.

const VERIFICATION_SCENE: PackedScene = preload("res://scenes/verification.tscn")
const SIZES: Array[Vector2i] = [Vector2i(360, 640), Vector2i(720, 1280)]

var _passed: int = 0
var _failed: int = 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	for test_size: Vector2i in SIZES:
		var completed: Variant = await _test_screen(test_size)
		_expect(completed == true, "screen test finishes at %s" % test_size)
	if OS.get_cmdline_user_args().has("--force-failure"):
		_expect(false, "deliberate failure proves non-zero exit")
	print("BOOTSTRAP_TESTS passed=%d failed=%d" % [_passed, _failed])
	quit(1 if _failed > 0 else 0)


func _test_screen(test_size: Vector2i) -> bool:
	var viewport: SubViewport = SubViewport.new()
	viewport.size = test_size
	root.add_child(viewport)
	var screen: Control = VERIFICATION_SCENE.instantiate() as Control
	viewport.add_child(screen)
	await process_frame
	await process_frame
	var button: Button = screen.get_node("SafeMargin/Content/VerifyButton") as Button
	var counter: Label = screen.get_node("SafeMargin/Content/Counter") as Label
	var status: Label = screen.get_node("SafeMargin/Content/Status") as Label
	var info: Label = screen.get_node("SafeMargin/Content/RuntimeInfo") as Label
	_expect(counter.text == "Interactions : 0", "counter starts at zero at %s" % test_size)
	_expect(viewport.gui_get_focus_owner() == button, "button has initial keyboard focus at %s" % test_size)
	_expect(info.text.contains(str(Engine.get_version_info().get("string", "unknown"))), "engine version is visible")
	_expect(info.text.contains(OS.get_name()), "platform is visible")
	button.pressed.emit()
	_expect(counter.text == "Interactions : 1", "first signal reaches the counter")
	button.pressed.emit()
	_expect(counter.text == "Interactions : 2", "second signal increments once")
	_expect(status.text == "Interaction reçue. Le bouton répond.", "input receives a textual acknowledgement")
	var bounds: Rect2 = Rect2(Vector2.ZERO, Vector2(test_size))
	for node: Node in screen.find_children("*", "Control", true, false):
		var control: Control = node as Control
		_expect(bounds.encloses(control.get_global_rect()), "%s fits at %s" % [screen.get_path_to(control), test_size])
	viewport.queue_free()
	await process_frame
	return true


func _expect(condition: bool, description: String) -> void:
	if condition:
		_passed += 1
	else:
		_failed += 1
		push_error("BOOTSTRAP_FAIL %s" % description)
