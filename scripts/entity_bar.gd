class_name EntityBar extends Node2D

enum bar_types {red, yellow}


@export var type : bar_types = bar_types.red
@export var show_duration : float = 1
@export var fade_duration : float = 0.3

@onready var opacity_tween : Tween = get_tree().create_tween()
@onready var frames : AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frames.play(str(type))
	frames.pause()
	frames.frame = 5
	frames.modulate.a = 0.0

func update_bar(value : float, max_value : float, difference : float) -> void:
	frames.modulate.a = 1.0
	opacity_tween.kill()
	opacity_tween = get_tree().create_tween()
	opacity_tween.tween_interval(show_duration)
	opacity_tween.tween_property(frames, "modulate:a", 0.0, fade_duration)
	opacity_tween.play()
	frames.frame = round((value / max_value) * 6)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
