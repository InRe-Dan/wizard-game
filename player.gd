extends CharacterBody2D

@export var projectile : PackedScene
@export var maxSpeed : float = 100
@export var acceleration : float = 1000
@export var damping : float = 10.
@export var dashSpeed : float = 300.
@export var recoil : float = 100.
var aim : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var weapon = preload("res://weapons/FireStaff.tscn").instantiate()
	weapon.name = "Staff"
	add_child(weapon)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	var move : Vector2 = Input.get_vector("left", "right", "up", "down");
	aim = Input.get_vector("aimleft", "aimright", "aimup", "aimdown");
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
		$Staff.use(self)
	if Input.is_action_just_pressed("ability"):
		velocity = move.normalized() * dashSpeed
	velocity += acceleration * delta * move
	velocity *= 1. / (1. + damping * delta)
	move_and_slide()


