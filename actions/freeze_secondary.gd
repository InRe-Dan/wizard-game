class_name FreezeSecondaryAction extends Action

@export var buildup : float = 3

func _ready() -> void:
	description = "Apply freeze buildup to targets"
	expected_cooldown = 0

func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	var effect : FrozenEffect = FrozenEffect.new()
	effect.buildup = buildup
	if secondary:
		secondary.distribute_signal(AddEffectEvent.new(effect))
	else:
		push_error("Incorrect use of freeze secondary action.")
	finished.emit()
