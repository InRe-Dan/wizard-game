extends Effect

var res : EntityResource = preload("res://resources/entities/water_spirit.tres")

func _init() -> void:
	icon = null
	effect_name = "Blessing of Life"
	effect_description = "The gods will you to live!"

func protect() -> void:
	var shoot : RadialShootAction = RadialShootAction.new(res, 0, 20, 12)
	add_child(shoot)
	shoot.finished.connect(queue_free)
	shoot.do(parent, null, parent.global_position.direction_to(parent.looking_at))

func handle_event(event : Event) -> Event:
	if event is DeathEvent:
		event.free()
		parent.health = round(parent.resource.starting_health * 0.3)
		protect()
		return null
	return event

