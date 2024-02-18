class_name TakeDamageEvent extends Event

var damage : DamageData
var dealer : Entity

func _init(dealer : Entity, damage : DamageData) -> void:
	type = types.take_damage
	self.damage = damage
	self.dealer = dealer
