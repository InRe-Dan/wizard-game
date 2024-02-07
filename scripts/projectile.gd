class_name Projectile extends Node2D

enum Team {Player, Enemies, Any}

var direction : Vector2
@export var team : Team = Team.Player
@export var velocity : float = 200
@export var damage : int = 1
@export var knockback : float = 200.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * velocity * delta
	
func set_attributes(dir : Vector2, pos : Vector2, team : Team) -> void:
	direction = dir
	global_position = pos
	self.team = team
	
func despawn() -> void:
	queue_free()
