class_name EntityBar extends Node2D

enum bar_types {red, yellow}


@export var type : bar_types = bar_types.red
@export var show_duration : float = 0.5
@onready var frames : AnimatedSprite2D = $AnimatedSprite2D

var time_to_show : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frames.play(str(type))
	frames.pause()
	frames.frame = 5
	hide()

func update_bar(value : float, max_value : float, difference : float) -> void:
	show()
	time_to_show = show_duration
	frames.frame = round((value / max_value) * 6) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if time_to_show > 0:
		time_to_show -= delta
		if time_to_show <= 0:
			hide()
