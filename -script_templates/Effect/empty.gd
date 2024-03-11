extends Effect

func _init() -> void:
	pass

func _process(delta : float) -> void:
	pass
	
func handle_event(event : Event) -> Event:
	push_error("Unimplemented effect behaviour!")
	return null
