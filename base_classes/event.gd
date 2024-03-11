@icon("res://assets/editor_icons/engine/StatusWarning.svg")

class_name Event extends Node

enum types {
inputmove, inputcommand, collision, 
has_hit, been_hit, take_damage, 
dealt_damage, damage_nullified, 
death, speech, created_projectile,
attempt_move, has_moved, has_interacted, been_interacted}

var type : types
