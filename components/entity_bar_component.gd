class_name EntityBar extends Node2D

enum bar_types {red, yellow}
enum bar_show_rules {always, when_not_full, on_hit}

# These exports can be improved. Relevant github issue:
# https://github.com/godotengine/godot-proposals/issues/2582

@export var type : bar_types = bar_types.red
@export var show_rule : bar_show_rules = bar_show_rules.on_hit
@export var show_duration : float = 1
@export var fade_duration : float = 0.3

@onready var opacity_tween : Tween = get_tree().create_tween()
@onready var frames : AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frames.play(str(type))
	frames.pause()
	frames.frame = 5
	if show_rule != bar_show_rules.always:
		frames.modulate.a = 0.0

func update_bar(percentage : float) -> void:
	match show_rule:
		bar_show_rules.on_hit:
			frames.modulate.a = 1.0
			opacity_tween.kill()
			opacity_tween = get_tree().create_tween()
			opacity_tween.tween_interval(show_duration)
			opacity_tween.tween_property(frames, "modulate:a", 0.0, fade_duration)
			opacity_tween.play()
			frames.frame = round(percentage * 6)
		bar_show_rules.when_not_full:
			frames.frame = round(percentage * 6)
			if percentage < 0.999:
				frames.modulate.a = 1.0
			else:
				frames.modulate.a = 0.0
		bar_show_rules.always:
			frames.frame = round(percentage * 6)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
