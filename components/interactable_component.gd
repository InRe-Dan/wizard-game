extends EntityComponent

@export var detection_area : Area2D

func receive_signal(event : Event) -> Event:
	if event.type == event.types.been_interacted:
		var input : BeenInteractedEvent = event as BeenInteractedEvent
		parent.velocity += 30 * - input.dir_from
	return event
