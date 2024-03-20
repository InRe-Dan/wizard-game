class_name DamageData extends Resource

enum KnockbackTypes {origin, velocity}
enum DamageTypes {kinetic, fire, water, ice}

@export var damage : float
@export var damage_type : DamageTypes = DamageTypes.kinetic
@export var knockback_type : KnockbackTypes = KnockbackTypes.velocity
@export var knockback_velocity : float = 0
