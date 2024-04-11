extends EntityComponent

@export var detection_area : Area2D
@export var one_shot : bool = false

func receive_signal(event : Event) -> Event:
	if event is BeenInteractedEvent and one_shot:
		queue_free()
	return event
