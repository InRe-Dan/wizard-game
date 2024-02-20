class_name DeathEffectComponent extends EntityComponent

func receive_signal(event : Event) -> Event:
	if event.type == event.types.death:
		for child : DeathEffect in get_children():
			child.trigger()
	return event
