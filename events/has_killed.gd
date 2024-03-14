class_name HasKilledEvent extends Event

var target : Entity

func _init(victim : Entity) -> void:
	type = types.has_killed
	target = victim

