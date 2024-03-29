class_name HealTargetAction extends Action
## Heals specific target. Has nothing to do with do() params.

@export var amount : int = 1
@export var target : Entity = null



func _init(heal_target : Entity = null, amount : int = 0) -> void:
	if not target:
		if heal_target:
			target = heal_target
	if amount:
		self.amount = amount
	

func _ready() -> void:
	description = "Heals another entity"
	expected_cooldown = 0

func do(caller : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	if not target:
		push_error("No target provided to heal_target action.")
	if is_instance_valid(target):
		target.distribute_signal(TryHealEvent.new(amount))
