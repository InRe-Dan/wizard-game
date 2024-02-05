class_name Enemy extends CharacterBody2D


@export var speed : float = 50.0
@export var health : int = 10
@export var acceleration : float = 400.0
@export var damping : float = 10.0

@onready var player : Player = get_node("/root/Globals").player
@onready var avoidance_vision : AvoidanceVision = $AvoidanceVision
@onready var health_bar : EntityBar = $EntityBar

var target_direction : Vector2

var next_frame_knockback : Vector2
var max_health : int;

func _ready() -> void:
	# tell the avoidance helper that we want to get to the player
	max_health = health
	# set our target direction to be towards the player at first

func _process(delta: float) -> void:
	# tell the avoidance system where we are trying to go
	# weigh our previous target destination (which was influenced by the helper) with the suggestion
	target_direction = 0.5 * (player.global_position - global_position).normalized()\
					+ 0.5 * avoidance_vision.sum\
					+ 0.0 * target_direction.normalized()
	velocity += target_direction.normalized() * acceleration * delta
	velocity += next_frame_knockback
	velocity = velocity / (1 + damping * delta)
	next_frame_knockback = Vector2(0, 0)
	if velocity.length() > 0:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	
	if velocity.x >= 0:
		$AnimatedSprite2D.scale.x = 1.
	else:
		$AnimatedSprite2D.scale.x = -1.
	
	move_and_slide()

func hit(proj : Projectile) -> void:
	print("Ouch!!")
	next_frame_knockback = proj.knockback * proj.direction.normalized()
	health -= proj.damage
	health_bar.update_bar(float(health) / float(max_health))
	if health <= 0:
		queue_free()
