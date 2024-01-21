extends CharacterBody2D

@export var projectile : PackedScene
@export var maxSpeed : float = 100
@export var acceleration : float = 1000
@export var damping : float = 10.
@export var dashSpeed : float = 300.
@export var recoil : float = 100.
var weapons = [preload("res://scenes/weapon.tscn").instantiate().setResource(load("res://resources/FireStaff.tres")), preload("res://scenes/weapon.tscn").instantiate().setResource(load("res://resources/IceStaff.tres"))]
var weaponIndex = 0
var aim : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
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
		weapons[weaponIndex].use(self)
		$ShootPlayer.play()
	if Input.is_action_just_pressed("ability") and $DashCooldown.is_stopped():
		velocity = move.normalized() * dashSpeed
		$DashCooldown.start()
		$DashPlayer.play()
		$DashBar.show()
		$DashBar.play()
	
	if Input.is_action_just_pressed("cycleforward"):
		_switch_weapon(1)
	elif Input.is_action_just_pressed("cyclebackward"):
		_switch_weapon(-1)
	
	velocity += acceleration * delta * move
	velocity *= 1. / (1. + damping * delta)
	move_and_slide()

func _switch_weapon(direction : int) -> void:
	weaponIndex += direction
	if weaponIndex < 0:
		weaponIndex = weapons.size() - 1
	if weaponIndex >= weapons.size():
		weaponIndex = 0
		

func hide_dash() -> void:
	$DashBar.hide()
	$DashBar.stop()
