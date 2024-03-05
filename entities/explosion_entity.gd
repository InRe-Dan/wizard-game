extends Entity

var sound : AudioStream = preload("res://assets/sounds/explosion.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioHandler.play_sound(sound, global_position)
	FloorHandler.melt_ice(global_position, 96)
	get_tree().get_first_node_in_group("camera").shake(0.3)
	FloorHandler.add_fire(global_position, 32)
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
