extends Entity

var hit_sound : AudioStream = preload("res://assets/sounds/player_hurt.wav")
var use_sound : AudioStream = preload("res://assets/sounds/use_sound.wav")
var dash_cooldown_timer : float = 0.0

func _physics_process(delta: float) -> void:
	super(delta)
	dash_cooldown_timer -= delta

func distribute_signal(event : Event) -> void:
	if event.type == event.types.take_damage:
		AudioHandler.play_sound(hit_sound, global_position)
		get_tree().get_first_node_in_group("camera").shake(0.3)
	elif event.type == event.types.created_projectile:
		AudioHandler.play_sound(use_sound, global_position)
	elif event.type == event.types.inputcommand:
		var input : InputCommand = event as InputCommand
		if input.command == input.Commands.dash and dash_cooldown_timer <= 0.01:
			dash_cooldown_timer = 0.3
			velocity += last_move_input * 200
	super(event)
