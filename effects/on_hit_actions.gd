extends Effect

func _init(action : Action = null) -> void:
	if action:
		add_child(action)
	
func handle_event(event : Event) -> Event:
	if event.type == event.types.has_hit:
		var hit : HasHitEvent = event as HasHitEvent
		for child : Action in get_children():
			child.do(get_parent().parent, hit.target)
	return event
