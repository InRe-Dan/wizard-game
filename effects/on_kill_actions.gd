class_name KillActionsEffect extends Effect

func _init(action : Action = null) -> void:
	if action:
		add_child(action)
	
func handle_event(event : Event) -> Event:
	if event.type == event.types.has_killed:
		for child : Action in get_children():
			var kill_event : HasKilledEvent = event as HasKilledEvent
			child.do(get_parent().parent, kill_event.target)
	if event.type == event.types.add_effect:
		var add_event : AddEffectEvent = event as AddEffectEvent
		if add_event.effect is KillActionsEffect:
			var effect : KillActionsEffect = add_event.effect as KillActionsEffect
			for child : Node in effect.get_children():
				child.reparent(self)
			updated.emit(self)
			add_event.queue_free()
			return null

	return event

