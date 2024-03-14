extends EntityComponent

func receive_signal(event : Event) -> Event:
	for effect : Node in get_children():
		event = effect.call("handle_event", event)
	
	if event.type == event.types.add_effect:
		add_child((event as AddEffectEvent).effect) 
	return event

