extends Effect

func _init() -> void:
	icon = null
	effect_name = ""
	effect_description = ""

func _process(delta : float) -> void:
	pass
	
func handle_event(event : Event) -> Event:
	if event is TakeDamageEvent:
		if event.damage.damage_type == DamageData.DamageTypes.fire:
			get_parent().parent.queue_free()
			FloorHandler.add_water(get_parent().parent.global_position, 16)
	return event

