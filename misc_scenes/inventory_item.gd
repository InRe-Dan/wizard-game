@icon("res://assets/editor_icons/engine/Override.svg")
class_name InventoryItem extends Node

var description : String

@export var item_name : String
@export var uses : int
@export var max_uses : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for action : Action in get_children():
		description += action.description + ". "

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func use(owner : Entity, direction : Vector2) -> void:
	for action : Action in get_children():
		print(name)
		action.do(owner, null, direction)
