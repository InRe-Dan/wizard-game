extends CharacterBody2D

@export var maxSpeed : float = 100
@export var acceleration : float = 1000
@export var damping : float = 10.
@export var dashSpeed : float = 300.
@export var recoil : float = 100.
var aim : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	var move : Vector2 = Input.get_vector("left", "right", "up", "down");
	aim = Input.get_vector("aimleft", "aimright", "aimup", "aimdown");
	if aim.length() < 0.1:
		if move.length() > 0:
			aim = move
		else:
			aim = Vector2(1., 0.)
	aim = aim.normalized()
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
		$ShootPlayer.play()
	if Input.is_action_just_pressed("click"):
		var mouse : Vector2 = get_viewport().get_mouse_position()
		mouse = mouse - Vector2(get_viewport().size / 6)
		aim = mouse - position
		aim = aim.normalized()
		velocity = -aim * recoil
		$ShootPlayer.play()
	if Input.is_action_just_pressed("ability") and $DashCooldown.is_stopped():
		velocity = move.normalized() * dashSpeed
		$DashCooldown.start()
		$DashPlayer.play()
		$DashBar.show()
		$DashBar.play()
	
	velocity += acceleration * delta * move
	velocity *= 1. / (1. + damping * delta)
	move_and_slide()

func hide_dash() -> void:
	$DashBar.hide()
	$DashBar.stop()
