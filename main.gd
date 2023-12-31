extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_shoot(direction : Vector2):
	direction = direction.normalized()
	var newProj : Node = $Player.projectile.instantiate()
	newProj.setVelocity(direction)
	newProj.position = $Player.position
	add_child(newProj) # Replace with function body.
