extends Effect

func _init(action : Action = null) -> void:
	if action:
		add_child(action)
	
func handle_event(event : Event) -> Event:
	if event.type == event.types.death:
		for child : Action in get_children():
			child.do(get_parent().parent)
	return event

