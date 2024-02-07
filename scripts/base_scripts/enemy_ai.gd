class_name EnemyAI extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert((get_parent() as Enemy))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass	

func get_direction() -> Vector2:
	push_error("abstract function")
	return Vector2()