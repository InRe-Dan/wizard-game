extends Entity

var sound : AudioStream = preload("res://assets/sounds/splash.wav")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func distribute_signal(event : Event) -> void:
	if event.type == Event.types.death:
		AudioHandler.play_sound(sound, global_position)
	super(event)
