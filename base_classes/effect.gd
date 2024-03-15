@icon("res://assets/editor_icons/engine/KeyAudio.svg")
class_name Effect extends Node

var effect_name : String = "Unnamed effect"
var effect_description : String = "Unknown behaviour"
var is_visible : bool = true
var icon : Texture2D = preload("res://assets/placeholder_icon.png")

func handle_event(event : Event) -> Event:
	push_error("Unimplementedeffect behaviour!")
	return null
