class_name CanInteractComponent extends EntityComponent

@export var detection_area : Area2D

func interactable_found() -> bool:
	return not detection_area.get_overlapping_areas().is_empty()

func receive_signal(event : Event) -> Event:
	if event.type == event.types.inputcommand:
		var input : InputCommand = event as InputCommand
		if input.Commands.interact == input.command:
			var area : Area2D = detection_area.get_overlapping_areas().front()
			if area:
				var entity : Entity = area.get_parent().get_parent() as Entity
				if entity:
					entity.distribute_signal(BeenInteractedEvent.new(parent, - input.direction))
					parent.distribute_signal(HasInteractedEvent.new(entity, input.direction))
	return event
