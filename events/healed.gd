class_name HealedEvent extends Event

var amount : int

func _init(health : int) -> void:
	type = types.healed
	amount = health

