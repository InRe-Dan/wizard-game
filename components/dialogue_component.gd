extends EntityComponent

func receive_signal(event : Event) -> Event:
	if event as SpeechEvent:
		DialogueHandler.say(parent, event as SpeechEvent)
	return event
