class_name HasHitEvent extends Event

var target : Entity
var damage : DamageData
var multiplier : float = 1

func _init(target: Entity, damage : DamageData) -> void:
	self.target = target
	self.damage = damage
	type = types.has_hit
	
