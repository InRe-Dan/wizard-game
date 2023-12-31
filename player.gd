extends CharacterBody2D

@export var projectile : PackedScene
signal shoot(direction)
@export var maxSpeed : float = 100
@export var acceleration : float = 1000
@export var damping : float = 10.
@export var dashSpeed : float = 300.
@export var recoil : float = 100.
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var move : Vector2 = Input.get_vector("left", "right", "up", "down");
	var aim : Vector2 = Input.get_vector("aimleft", "aimright", "aimup", "aimdown");
	if aim.length() < 0.1:
		aim = Vector2(1., 0.)
	if move.length() > 0:
		$Animation.play("run")
	else:
		$Animation.play("idle")

	if move.x < 0:
		$Animation.scale.x = -1.
	elif move.x > 0:
		$Animation.scale.x = 1.

	if Input.is_action_just_pressed("shoot"):
		velocity = - aim * recoil
		shoot.emit(aim)
	if Input.is_action_just_pressed("ability"):
		velocity = move.normalized() * dashSpeed
	velocity += acceleration * delta * move
	velocity *= 1. / (1. + damping * delta)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Hello!")
	velocity = Vector2(0., 0.)	
