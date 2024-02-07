class_name EnemyWeapon extends Node

@export var effective_range : float = 500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(get_parent() as EnemyAttackController)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func use(user : Enemy, target : Vector2) -> void:
	push_error("Unimplemented abstract function was called!")
