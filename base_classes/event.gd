@icon("res://assets/editor_icons/engine/StatusWarning.svg")

class_name Event extends RefCounted

enum types {
inputmove, inputcommand, collision, 
has_hit, been_hit, take_damage, 
dealt_damage, damage_nullified, 
death, speech, created_projectile,
attempt_move, has_moved, has_interacted, been_interacted,
add_effect, try_heal, healed, has_killed, item_consumed, dashed, custom}

var type : types
