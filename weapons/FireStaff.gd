extends Node2D

@export var projectile : PackedScene;

signal shotProjectile(projectile)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func use(character : Node2D) -> void:
	var proj = projectile.instantiate()
	proj.position = character.position
	proj.setVelocity(character.aim)
	get_tree().call_group("main", "_create_new_projectile", proj)
