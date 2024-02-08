class_name RangedAttackController extends EnemyAttackController

@onready var parent : Enemy = get_parent()
@onready var weapon : EnemyWeapon = $FireBreath as EnemyWeapon


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func try_attack(entity : Player) -> bool:
	if (parent.global_position - entity.global_position).length() < weapon.effective_range:
		weapon.use(parent, entity.global_position)
		return true
	else:
		return false
