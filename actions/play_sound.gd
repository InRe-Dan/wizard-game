class_name PlaySoundAction extends Action

@export var sound : AudioStream
@export_range(0, 1) var frequency : float = 1

func _init(audio : AudioStream = null) -> void:
	if not sound:
		if audio:
			sound = audio

func _ready() -> void:
	description = ""
	expected_cooldown = 0

func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	if frequency >= randf():
		AudioHandler.play_sound(sound, target.global_position)
