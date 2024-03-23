class_name OnSpawnActionsEffect extends Effect

func _init() -> void:
	icon = null
	effect_name = ""
	effect_description = ""

func _process(delta : float) -> void:
	for i : Action in get_children():
		i.do(get_parent().parent)
	queue_free()

func handle_event(event : Event) -> Event:
	return event

