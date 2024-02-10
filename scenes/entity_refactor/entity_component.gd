class_name EntityComponent extends Node2D

@onready var parent : Entity = get_parent() as Entity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func receive_signal(emitter : Entity, event : Event) -> Event:
	return event
