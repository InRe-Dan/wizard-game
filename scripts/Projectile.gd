class_name Projectile extends Node2D

var direction : Vector2
@export var velocity : float = 200

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * velocity * delta
	
func set_attributes(dir : Vector2, pos : Vector2) -> void:
	direction = dir
	position = pos
	
func despawn() -> void:
	queue_free()
	
