@icon("res://assets/editor_icons/engine/KeyAudio.svg")
class_name Effect extends Node

@export var effect_name : String = "Unnamed effect"
@export_multiline var effect_description : String = "Unknown behaviour"
@export var is_visible : bool = true

func handle_event(event : Event) -> Event:
	push_error("Unimplementedeffect behaviour!")
	return null
