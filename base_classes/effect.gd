@icon("res://assets/editor_icons/engine/KeyAudio.svg")
class_name Effect extends Node

signal updated(effect : Effect)
var effect_name : String = "Unnamed effect"
var effect_description : String = "Unknown behaviour"
var icon : Texture2D = PlaceholderTexture2D.new()
var is_visible : bool = true
## Can be null - indicates that this is a temporary debuff or buff
var resource : PassiveResource = null
@onready var parent : Entity = get_parent().parent

func handle_event(event : Event) -> Event:
	push_error("Unimplementedeffect behaviour!")
	return null
	
func set_resource(res : PassiveResource) -> void:
	resource = res
	effect_name = res.passive_name
	icon = res.icon
