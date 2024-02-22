class_name TakeDamageEvent extends Event

var damage : DamageData
var direction : Vector2

func _init(damage : DamageData, direction : Vector2) -> void:
	type = types.take_damage
	self.damage = damage
	self.direction = direction
