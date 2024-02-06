class_name EnemyWeapon extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(get_parent() as EnemyAttackController)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func use() -> bool:
	push_error("Unimplemented abstract function was called!")
	return false;
