class_name Enemy extends CharacterBody2D


@export var speed : float = 50.0
@export var health : int = 10
@export var acceleration : float = 400.0
@export var damping : float = 10.0
@onready var player : Player = get_node("/root/Globals").player

signal taken_damage(h : int, max_h : int, damage : int)

var next_frame_knockback : Vector2
var max_health : int;

func _ready() -> void:
	max_health = health

func _process(delta: float) -> void:
	velocity += (player.position - position).normalized() * acceleration * delta
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
	taken_damage.emit(health, max_health, proj.damage)
	if health <= 0:
		queue_free()
