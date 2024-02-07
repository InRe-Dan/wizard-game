class_name EnemyAttackController extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(get_parent() as Enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func try_attack(entity : Player) -> bool:
	push_error("unimplemented abstract method")
	return false
