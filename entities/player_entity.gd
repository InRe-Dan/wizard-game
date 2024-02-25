extends Entity

var hit_sound : AudioStream = preload("res://assets/sounds/player_hurt.wav")
var use_sound : AudioStream = preload("res://assets/sounds/use_sound.wav")

func distribute_signal(event : Event) -> void:
	if event.type == event.types.take_damage:
		AudioHandler.play_sound(hit_sound, global_position)
	elif event.type == event.types.created_projectile:
		AudioHandler.play_sound(use_sound, global_position)
	super(event)
