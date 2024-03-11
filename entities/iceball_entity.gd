extends Entity

var sound : AudioStream = preload("res://assets/sounds/snow_blast.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioHandler.play_sound(sound, global_position)
	super()
