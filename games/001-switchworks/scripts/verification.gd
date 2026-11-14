extends Control
## A technical bootstrap screen, not the game's future interface.

var interaction_count: int = 0

@onready var _safe_margin: MarginContainer = %SafeMargin
@onready var _runtime_info: Label = %RuntimeInfo
@onready var _verify_button: Button = %VerifyButton
@onready var _counter: Label = %Counter
@onready var _status: Label = %Status


func _ready() -> void:
	var version: String = str(Engine.get_version_info().get("string", "unknown"))
	_runtime_info.text = "Godot %s\n%s · GDScript typé" % [version, OS.get_name()]
	_verify_button.pressed.connect(_on_verify_pressed)
	get_viewport().size_changed.connect(_apply_safe_area)
	_apply_safe_area()
	_verify_button.grab_focus()
	print("BOOTSTRAP_READY platform=%s engine=%s" % [OS.get_name(), version])


func _on_verify_pressed() -> void:
	interaction_count += 1
	_counter.text = "Interactions : %d" % interaction_count
	_status.text = "Interaction reçue. Le bouton répond."
	print("BOOTSTRAP_INPUT count=%d" % interaction_count)


func _apply_safe_area() -> void:
	if not (OS.has_feature("android") or OS.has_feature("ios")):
		return
	var window_size: Vector2i = DisplayServer.window_get_size()
	if window_size.x <= 0 or window_size.y <= 0:
		return
	var window_rect: Rect2 = Rect2(Vector2(DisplayServer.window_get_position()), Vector2(window_size))
	var safe_rect: Rect2 = Rect2(DisplayServer.get_display_safe_area()).intersection(window_rect)
	if not safe_rect.has_area():
		return
	var ui_scale: Vector2 = get_viewport_rect().size / Vector2(window_size)
	_safe_margin.add_theme_constant_override("margin_left", 24 + int((safe_rect.position.x - window_rect.position.x) * ui_scale.x))
	_safe_margin.add_theme_constant_override("margin_top", 24 + int((safe_rect.position.y - window_rect.position.y) * ui_scale.y))
	_safe_margin.add_theme_constant_override("margin_right", 24 + int((window_rect.end.x - safe_rect.end.x) * ui_scale.x))
	_safe_margin.add_theme_constant_override("margin_bottom", 24 + int((window_rect.end.y - safe_rect.end.y) * ui_scale.y))
