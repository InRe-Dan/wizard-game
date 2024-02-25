extends Camera2D
# Code adapted from https://www.reddit.com/r/godot/comments/eu5eyv/sprite_jittering/
# More potential solutions https://github.com/godotengine/godot/issues/35606
# r/godot, u/forbjok

# Smoothing duration in seconds
var SMOOTHING_DURATION : float = 0.1
# Current position of the camera
var current_position: Vector2
# Position the camera is moving towards
var destination_position: Vector2

func _ready() -> void:
	current_position = global_position

func _physics_process(delta: float) -> void:
	var target: Node2D = get_tree().get_first_node_in_group("players") as Node2D
	if target:
		destination_position = target.global_position
	current_position += Vector2(destination_position.x - current_position.x, destination_position.y - current_position.y) / SMOOTHING_DURATION * delta
	global_position = current_position.round()
	force_update_scroll()
