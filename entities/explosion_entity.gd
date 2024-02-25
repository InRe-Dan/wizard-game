extends Entity

var sound : AudioStream = preload("res://assets/sounds/explosion.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioHandler.play_sound(sound, global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
