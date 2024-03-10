extends EntityComponent

@export var detection_area : Area2D

func receive_signal(event : Event) -> Event:
	if event.type == event.types.inputcommand:
		var input : InputCommand = event as InputCommand
		if input.Commands.interact == input.command:
			parent.say("Poke!")
	return event
