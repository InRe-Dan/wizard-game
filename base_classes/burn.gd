class_name BurnAction extends Action

var buildup : float = 0

func _init(buildup : float) -> void:
	self.buildup = buildup
func _ready() -> void:
	description = "Sets target on fire"
	expected_cooldown = 0

func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	var burn_effect : Effect = FireEffect.new()
	burn_effect.buildup = buildup
	secondary.distribute_signal(AddEffectEvent.new(burn_effect))

