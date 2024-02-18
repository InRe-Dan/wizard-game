class_name BeenHitEvent extends Event

var dealer : Entity
var damage : DamageData

func _init(dealer: Entity, damage : DamageData) -> void:
	self.dealer = dealer
	self.damage = damage
	type = types.been_hit
