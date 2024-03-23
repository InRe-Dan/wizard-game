class_name ActionOnEventEffect extends Effect

@export var event_type : Event.types

func _init() -> void:
	icon = null
	effect_name = ""
	effect_description = ""

func _process(delta : float) -> void:
	pass
	
func handle_event(event : Event) -> Event:
	if event.type == event_type:
		for i : Node in get_children():
			(i as Action).do(get_parent().parent)
	return event
	


