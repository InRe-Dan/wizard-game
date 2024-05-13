class_name ActionOnEventEffect extends Effect

@export_enum("None", "Towards velocity", "Towards target", "Towards last aim") var direction_mode : int = 0

@export var event_types : Array[Event.types]

func _init() -> void:
	icon = null
	effect_name = ""
	effect_description = ""
	
func handle_event(event : Event) -> Event:
	if event_types.has(event.type):
		var dir : Vector2
		var parent : Entity = get_parent().get_parent()
		match direction_mode:
			1:
				dir = parent.velocity
			2:
				dir = parent.global_position.direction_to(parent.looking_at)
			3:
				dir = parent.last_move_input
		dir = dir.normalized()
		for i : Node in get_children():
			if direction_mode == 0:
				(i as Action).do(get_parent().parent)
			(i as Action).do(get_parent().parent, null, dir)
	return event
	


