extends EntityComponent

func receive_signal(event : Event) -> Event:
	for effect : Node in get_children():
		event = effect.call("handle_event", event)
	return event

