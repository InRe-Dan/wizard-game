extends Entity

@export var min_damage : float
@export var max_damage : float
@export var min_speed : float
@export var max_speed : float

func _ready() -> void:
	super()

func distribute_signal(event : Event) -> void:
	if event is CollisionEvent:
		if event.velocity_lost > 30:
			print("High speed lost")
			distribute_signal(DeathEvent.new())
			if event.entity:
				var damage : DamageData = DamageData.new()
				var damage_percentage : float = clamp((event.velocity.length() - min_speed) / (max_speed / min_speed), 0, 1)
				damage.damage = damage_percentage * max_damage + min_damage
				damage.damage_type = damage.DamageTypes.kinetic
				damage.knockback_type = damage.KnockbackTypes.origin
				damage.knockback_velocity = event.velocity.length()
				event.entity.distribute_signal(BeenHitEvent.new(self, damage, 1.0))
	super(event)

