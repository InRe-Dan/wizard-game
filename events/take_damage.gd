class_name TakeDamageEvent extends Event

var damage : DamageData
var direction : Vector2
var multiplier : float

func _init(damage : DamageData, direction : Vector2, multiplier : float) -> void:
	type = types.take_damage
	self.damage = damage
	self.direction = direction
	self.multiplier = multiplier
