@icon("res://assets/editor_icons/engine/Override.svg")
class_name InventoryItem extends Node

var description : String

@export var item_name : String = "Unknown"
@export var uses : int = 3
@export var max_uses : int = 3

func _ready() -> void:
	for action : Action in get_children():
		description += action.description + ". "

func _process(delta: float) -> void:
	pass

func use(owner : Entity, direction : Vector2) -> void:
	for action : Action in get_children():
		print(name)
		action.do(owner, null, direction)
