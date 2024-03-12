@icon("res://assets/editor_icons/engine/Forward.svg")
class_name Action extends Node

static func a_or_an(string : String) -> String:
	if not "AEIOUaeiou".contains(string.left(1)):
		return "a " + string
	return "an " + string

var description : String = "Undefined action."
	
func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	push_error("Unimplemented action.")
