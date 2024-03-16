@icon("res://assets/editor_icons/engine/KeyAudio.svg")
class_name Effect extends Node

var effect_name : String = "Unnamed effect"
var effect_description : String = "Unknown behaviour"
var icon : Texture2D = PlaceholderTexture2D.new()
var is_visible : bool = true
## Can be null - indicates that this is a temporary debuff or buff
var resource : PassiveResource

func handle_event(event : Event) -> Event:
	push_error("Unimplementedeffect behaviour!")
	return null
