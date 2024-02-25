extends Entity

var hit_sound : AudioStream = preload("res://assets/sounds/enemy_hurt.wav")

func distribute_signal(event : Event) -> void:
	if event.type == event.types.take_damage:
		AudioHandler.play_sound(hit_sound, global_position)
	super(event)
