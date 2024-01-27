class_name FireBallItem extends Item

@export var projectile : PackedScene = preload("res://scenes/fireball.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func use(player : Player) -> void:
	player.shoot(projectile)
