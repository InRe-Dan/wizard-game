@icon("res://assets/editor_icons/engine/Forward.svg")
class_name Action extends Node

var description : String = "Undefined action."
	
func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	push_error("Unimplemented action.")
