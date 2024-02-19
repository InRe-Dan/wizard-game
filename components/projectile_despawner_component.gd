extends EntityComponent


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func receive_signal(event : Event) -> Event:
	match event.type:
		Event.types.collision:
			parent.queue_free()
		Event.types.dealt_damage:
			parent.queue_free()
	return event
