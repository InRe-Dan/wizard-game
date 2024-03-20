class_name DealtDamageEvent extends Event

var damage : DamageData
var target : Entity
var multiplier : float

func _init(target : Entity, damage : DamageData, multiplier : float) -> void:
	type = types.dealt_damage
	self.damage = damage
	self.target = target
	self.multiplier = multiplier
