class_name EntityComponent extends Node2D

@onready var parent : Entity = get_parent() as Entity

func receive_signal(event : Event) -> Event:
	return event
