class_name WorkshopTokens
extends Resource
## Source-of-truth tokens shared by the theme, authored objects and QA.

@export_group("Semantic colours")
@export var background := Color("e8ebe6")
@export var surface := Color("f5f3ea")
@export var ink := Color("183b47")
@export var muted := Color("52636a")
@export var primary := Color("234f5d")
@export var address_a := Color("306c87")
@export var address_b := Color("a9563f")
@export var success := Color("3b7158")
@export var error := Color("a63e32")
@export var disabled := Color("d9dfd8")
@export_group("Geometry and spacing")
@export var space_unit: int = 4
@export var edge: int = 16
@export var radius: int = 10
@export var touch_min: int = 48
@export var board_world_width: float = 6.35
@export_group("Type")
@export var brand_size: int = 12
@export var objective_size: int = 19
@export var body_size: int = 15
@export var caption_size: int = 12
@export var action_size: int = 17
