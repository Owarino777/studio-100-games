class_name PostalTheme
extends RefCounted

const INK := Color("203c56")
const CREAM := Color("f5efe2")
const CORAL := Color("edaa7d")
const FONT: FontFile = preload("res://assets/fonts/NunitoSans-Variable.ttf")


static func font(weight: float = 600.0) -> FontVariation:
	var result := FontVariation.new()
	result.base_font = FONT
	result.variation_opentype = {TextServerManager.get_primary_interface().name_to_tag("wght"): weight}
	return result


static func panel(color: Color = CREAM, radius: int = 18) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = color
	box.set_corner_radius_all(radius)
	box.border_color = Color("fffbf2")
	box.set_border_width_all(1)
	box.shadow_color = Color(0.18, 0.25, 0.27, 0.10)
	box.shadow_size = 4
	box.shadow_offset = Vector2(0, 2)
	box.set_content_margin_all(12)
	return box


static func make_theme() -> Theme:
	var theme := Theme.new()
	theme.default_font = font(650)
	theme.default_font_size = 17
	theme.set_color("font_color", "Label", INK)
	theme.set_color("font_color", "Button", INK)
	theme.set_color("font_hover_color", "Button", INK)
	theme.set_color("font_pressed_color", "Button", INK)
	theme.set_color("font_focus_color", "Button", INK)
	theme.set_color("font_disabled_color", "Button", Color("6b7c82"))
	theme.set_stylebox("normal", "Button", button_box())
	theme.set_stylebox("hover", "Button", button_box(Color("fff9ec")))
	theme.set_stylebox("pressed", "Button", button_box(Color("dce9df")))
	theme.set_stylebox("disabled", "Button", button_box(Color("e1e5df")))
	var focus := StyleBoxFlat.new()
	focus.bg_color = Color.TRANSPARENT
	focus.border_color = INK
	focus.set_border_width_all(3)
	focus.set_corner_radius_all(18)
	theme.set_stylebox("focus", "Button", focus)
	theme.set_color("font_color", "CheckButton", INK)
	theme.set_font_size("font_size", "CheckButton", 16)
	return theme


static func button_box(color: Color = CREAM) -> StyleBoxFlat:
	var result: StyleBoxFlat = panel(color)
	result.set_content_margin_all(8)
	return result
