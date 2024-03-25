class_name CustomCamera extends Camera2D
# Code adapted from https://www.reddit.com/r/godot/comments/eu5eyv/sprite_jittering/
# More potential solutions https://github.com/godotengine/godot/issues/35606
# r/godot, u/forbjok

@export var SMOOTHING_DURATION : float = 0.2
# https://gamedev.stackexchange.com/questions/1828/realistic-camera-screen-shake-from-explosion
@export var shake_radius : float = 2
@export var offset_scale : float = 0.2

var freecam : bool = false

var current_position: Vector2
var destination_position: Vector2
var is_shaking : bool = false
var shake_duration  : float = 0.0
var shake_time_elapsed : float = 0.0

func _ready() -> void:
	current_position = global_position

func _physics_process(delta: float) -> void:
	var target: Node2D = get_tree().get_first_node_in_group("players") as Node2D
	if target and not freecam:
		var vector_to_mouse : Vector2 = get_global_mouse_position() - target.global_position
		destination_position = target.global_position + offset_scale * vector_to_mouse
	elif freecam:
		var vector_to_mouse : Vector2 = get_global_mouse_position() - global_position 
		destination_position = global_position + 5 * offset_scale * vector_to_mouse
	current_position += Vector2(destination_position.x - current_position.x, destination_position.y - current_position.y) / SMOOTHING_DURATION * delta
	global_position = current_position.round()
	if is_shaking:
		global_position += (shake_time_elapsed / shake_duration) * shake_radius * Vector2.RIGHT.rotated(randf() * TAU)
		shake_time_elapsed += delta
		if shake_time_elapsed > shake_duration:
			is_shaking = false
	force_update_scroll()

func shake(duration : float) -> void:
	is_shaking = true
	shake_duration = duration
	shake_time_elapsed = 0.0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		print("baller")
		zoom += Vector2.ONE * 0.1
	elif event.is_action_pressed("zoom_out"):
		zoom -= Vector2.ONE * 0.1
