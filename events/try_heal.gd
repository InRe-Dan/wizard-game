class_name TryHealEvent extends Event

var amount : int

func _init(health : int) -> void:
	type = types.try_heal
	amount = health

