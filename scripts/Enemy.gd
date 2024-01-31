class_name Enemy extends CharacterBody2D


@export var speed : float = 50.0
@onready var player : Player = get_node("/root/Globals").player

func _process(delta: float) -> void:
	velocity = (player.position - position).normalized() * speed
	if velocity.length() > 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	
	if velocity.x >= 0:
		$AnimatedSprite2D.scale.x = 1.
	else:
		$AnimatedSprite2D.scale.x = -1.
	
	move_and_slide()

func hit() -> void:
	print("Ow!!")
	queue_free()
