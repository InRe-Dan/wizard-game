class_name Enemy extends CharacterBody2D


@export var speed : float = 50.0
@export var health : int = 10
@export var acceleration : float = 400.0
@export var damping : float = 10.0

@onready var avoidance_vision : AvoidanceVision = $AvoidanceVision
@onready var health_bar : EntityBar = $EntityBar
@onready var movement_controller : EnemyAI = $MovementController
@onready var attack_controller : EnemyAttackController = $AttackController
@onready var line_of_sight : Area2D = $Vision
@onready var hitbox : Area2D = $Hitbox
@onready var los_check : RayCast2D = $LosCheck


var target_direction : Vector2

var next_frame_knockback : Vector2
var max_health : int;

func _ready() -> void:
	# tell the avoidance helper that we want to get to the player
	max_health = health
	# set our target direction to be towards the player at first

func _physics_process(delta: float) -> void:
	if velocity.length() > 0.5:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")
	
	if velocity.x >= 0:
		$AnimatedSprite2D.scale.x = 1.
	else:
		$AnimatedSprite2D.scale.x = -1.
	velocity += next_frame_knockback
	velocity = velocity / (1 + damping * delta)
	next_frame_knockback = Vector2(0, 0)
	move_and_slide()

func hit(proj : Projectile) -> void:
	print("Ouch!!")
	next_frame_knockback = proj.knockback * proj.direction.normalized()
	health -= proj.damage
	health_bar.update_bar(float(health) / float(max_health))
	if health <= 0:
		queue_free()

func has_los_to(position : Vector2) -> bool:
	los_check.target_position = position
	los_check.force_raycast_update()
	return not los_check.is_colliding()
