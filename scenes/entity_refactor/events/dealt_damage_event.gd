class_name DealtDamageEvent extends Event

var damage : DamageData
var target : Entity

func _init(target : Entity, damage : DamageData) -> void:
	type = types.dealt_damage
	self.damage = damage
	self.target = target
