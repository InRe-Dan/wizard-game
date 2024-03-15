class_name HitActionsEffect extends Effect

func _init(action : Action = null) -> void:
	if action:
		add_child(action)
	
func handle_event(event : Event) -> Event:
	if event.type == event.types.has_hit:
		var hit_event : HasHitEvent = event as HasHitEvent
		for child : Action in get_children():
			child.do(get_parent().parent, hit_event.target)
	if event.type == event.types.add_effect:
		var add_event : AddEffectEvent = event as AddEffectEvent
		if add_event is AddEffectEvent:
			if add_event.effect is HitActionsEffect:
				var effect : HitActionsEffect = add_event.effect as HitActionsEffect
				for child : Node in effect.get_children():
					child.reparent(self)
				return null

	return event

