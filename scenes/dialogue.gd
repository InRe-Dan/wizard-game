class_name Dialogue extends Node2D

@onready var label : Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", -16, 0.3)
	tween.tween_interval(0.2)
	tween.tween_property(self, "modulate.a", 0.0, 0.5)
	tween.tween_callback(queue_free)

func set_parameters(text : String) -> void:
	label.text = text

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
