class_name WorkshopTheme
extends RefCounted

const TOKENS: WorkshopTokens = preload("res://ui/workshop/tokens.tres")


static func box(color: Color, radius: int = 10, padding: int = 12, border: Color = Color.TRANSPARENT) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = color
	style.set_corner_radius_all(radius)
	style.set_content_margin_all(padding)
	style.border_color = border
	style.set_border_width_all(1 if border.a > 0 else 0)
	return style


static func make(scale: float = 1.0) -> Theme:
	var t := Theme.new()
	t.default_font = PostalTheme.font(650)
	t.default_font_size = roundi(TOKENS.body_size * scale)
	t.set_color("font_color", "Label", TOKENS.ink)
	for variant: String in ["Brand", "Objective", "Caption", "Counter", "Status", "Result"]:
		t.set_type_variation(variant, "Label")
		var font_size: int = {"Brand": TOKENS.brand_size, "Objective": TOKENS.objective_size, "Caption": TOKENS.caption_size, "Counter": 20, "Status": TOKENS.body_size, "Result": 18}[variant]
		t.set_font_size("font_size", variant, roundi(font_size * scale))
		t.set_font("font", variant, PostalTheme.font(800 if variant in ["Objective", "Counter", "Result"] else 650))
		t.set_color("font_color", variant, TOKENS.muted if variant in ["Brand", "Caption"] else TOKENS.ink)
	for variant: String in ["Primary", "Quiet"]:
		t.set_type_variation(variant, "Button")
		t.set_font("font", variant, PostalTheme.font(800 if variant == "Primary" else 700))
		t.set_font_size("font_size", variant, roundi((TOKENS.action_size if variant == "Primary" else TOKENS.body_size) * scale))
		var fill: Color = TOKENS.primary if variant == "Primary" else TOKENS.surface
		for state: String in ["normal", "hover", "pressed", "disabled"]:
			var color: Color = fill.lightened(0.06) if state == "hover" else (fill.darkened(0.08) if state == "pressed" else fill)
			if state == "disabled": color = TOKENS.disabled
			t.set_stylebox(state, variant, box(color, TOKENS.radius, 10, Color(0.1, 0.2, 0.2, 0.12) if variant == "Quiet" else Color.TRANSPARENT))
		for state: String in ["font_color", "font_hover_color", "font_pressed_color", "font_focus_color"]:
			t.set_color(state, variant, TOKENS.surface if variant == "Primary" else TOKENS.ink)
		t.set_color("font_disabled_color", variant, Color("58665f"))
		var focus := box(Color.TRANSPARENT, TOKENS.radius, 0, TOKENS.ink)
		focus.set_border_width_all(3)
		t.set_stylebox("focus", variant, focus)
	t.set_stylebox("panel", "PanelContainer", StyleBoxEmpty.new())
	t.set_type_variation("ProgressChip", "PanelContainer")
	t.set_stylebox("panel", "ProgressChip", box(TOKENS.surface, 8, 8))
	t.set_type_variation("Modal", "PanelContainer")
	var modal: StyleBoxFlat = box(TOKENS.surface, 14, 20)
	modal.shadow_size = 12
	modal.shadow_color = Color(0.08, 0.15, 0.17, 0.18)
	t.set_stylebox("panel", "Modal", modal)
	t.set_font("font", "CheckButton", PostalTheme.font(650))
	t.set_font_size("font_size", "CheckButton", roundi(TOKENS.body_size * scale))
	t.set_color("font_color", "CheckButton", TOKENS.ink)
	return t
