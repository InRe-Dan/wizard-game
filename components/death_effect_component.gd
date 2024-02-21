class_name DeathEffectComponent extends EntityComponent

func receive_signal(event : Event) -> Event:
	if event.type == event.types.death:
		for child : Action in get_children():
			child.do(parent)
	return event
