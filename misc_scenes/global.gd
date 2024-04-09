extends Node

@onready var main : Main = get_tree().get_first_node_in_group("main") 
@onready var level : Level = get_tree().get_first_node_in_group("level")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
