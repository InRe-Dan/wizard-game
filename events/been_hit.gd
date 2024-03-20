class_name BeenHitEvent extends Event

var dealer : Entity
var damage : DamageData
var multiplier : float

func _init(dealer: Entity, damage : DamageData, multiplier : float) -> void:
	self.dealer = dealer
	self.damage = damage
	self.multiplier = multiplier
	type = types.been_hit
