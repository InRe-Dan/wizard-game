@icon("res://assets/editor_icons/engine/Override.svg")
class_name InventoryItem extends Node

var description : String

@export var item_name : String = "Unknown"
@export var item_icon : Texture2D = preload("res://assets/dungeon/flask_red.png")
@export var pickup_light_color : Color = Color.WHITE
@export var limited_use : bool = true
@export var uses : int = 3
@export var max_uses : int = 3

func _ready() -> void:
	for action : Action in get_children():
		description += action.description + ". "

func _process(delta: float) -> void:
	pass

func use(owner : Entity, direction : Vector2) -> bool:
	if limited_use:
		uses -= 1
	for action : Action in get_children():
		action.do(owner, null, direction)
	if uses == 0:
		return true
	return false
