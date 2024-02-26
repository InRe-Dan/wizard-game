extends EntityComponent

@export var min_range : float = 10
@export var max_range : float = 30
@export var lifetime : float = 0.5
@export var speed : float = 10

var label_scene : PackedScene = preload("res://misc_scenes/dialogue_text.tscn")

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func say(text : String, color : Color) -> void:
	var new_label : DialogueLabel = label_scene.instantiate() as DialogueLabel
	new_label.global_position = global_position + Vector2.from_angle(TAU * randf()) * (min_range + randf() * (max_range - min_range))
	new_label.text = text
	new_label.top_level = true
	new_label.lifetime = lifetime
	new_label.speed = speed
	new_label.modulate = color
	add_child(new_label)
	pass

func receive_signal(event : Event) -> Event:
	if event as SpeechEvent:
		say((event as SpeechEvent).text, (event as SpeechEvent).color)

	return event
