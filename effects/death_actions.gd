class_name DeathActionsEffect extends Effect

func _init(action : Action = null) -> void:
	if action:
		add_child(action)
	
func handle_event(event : Event) -> Event:
	if event.type == event.types.death:
		for child : Node in get_children():
			(child as Action).do(get_parent().parent)
	if event.type == event.types.add_effect:
		var add_event : AddEffectEvent = event as AddEffectEvent
		if add_event.effect is DeathActionsEffect:
			var effect : DeathActionsEffect = add_event.effect as DeathActionsEffect
			for child : Node in effect.get_children():
				child.reparent(self)
			updated.emit(self)
			add_event.effect.queue_free()
			add_event.queue_free()
			return null

	return event

