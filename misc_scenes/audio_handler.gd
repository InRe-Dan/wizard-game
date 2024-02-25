extends Node2D

@export var volume : float = 0.05
@export var pitch_variation : float = 0.3

@onready var camera : Camera2D = get_tree().get_first_node_in_group("camera")
@onready var bus_layout : AudioBusLayout = AudioServer.generate_bus_layout()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func play_sound(audio : AudioStream, pos : Vector2) -> void:
	var distance : float = (pos - camera.global_position).length()
	print(distance)
	var screen_lengths : float = 1 + (2 * distance / camera.get_viewport_rect().size.x)
	var player : AudioStreamPlayer = AudioStreamPlayer.new()
	print(screen_lengths)
	if screen_lengths > 3:
		player.bus = &"Distant"
	player.volume_db = linear_to_db(0.05 / screen_lengths)
	player.pitch_scale += pitch_variation * randf()
	player.stream = audio
	player.autoplay = true
	player.finished.connect(player.queue_free)
	add_child(player)
