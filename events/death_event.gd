class_name DeathEvent extends Event

var killer : Entity

func _init(killer : Entity) -> void:
	type = types.death
	self.killer = killer
	
