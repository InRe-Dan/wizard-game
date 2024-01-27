class_name Player extends CharacterBody2D

@export var maxSpeed : float = 100
@export var acceleration : float = 1000
@export var damping : float = 10.

@onready var inventory : Inventory = $Inventory
@onready var animation : AnimatedSprite2D = $Animation
@onready var root : Node2D = get_tree().get_first_node_in_group("main")

var last_aim_dir : Vector2
var move : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var globals : Node = get_node("/root/Globals")
	globals.player = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	move = Input.get_vector("left", "right", "up", "down");
	last_aim_dir = Input.get_vector("aimleft", "aimright", "aimup", "aimdown");
	if last_aim_dir.length() < 0.1:
		if move.length() > 0:
			last_aim_dir = move
		else:
			last_aim_dir = Vector2(1., 0.)
	last_aim_dir = last_aim_dir.normalized()
	if move.length() > 0:
		animation.play("run")
	else:
		animation.play("idle")

	if move.x < 0:
		animation.scale.x = -1.
	elif move.x > 0:
		animation.scale.x = 1.

	if Input.is_action_just_pressed("click"):
		var mouse : Vector2 = get_viewport().get_mouse_position()
		mouse = mouse - Vector2(get_viewport().size / 6)
		last_aim_dir = mouse - position
		last_aim_dir = last_aim_dir.normalized()
		inventory.use_selected(self)
	if Input.is_action_just_pressed("shoot"):
		inventory.use_selected(self)
	
	if Input.is_action_just_pressed("cycleforward"):
		inventory.next()
	if Input.is_action_just_pressed("cyclebackward"):
		inventory.prev()
	
	velocity += acceleration * delta * move
	velocity *= 1. / (1. + damping * delta)
	move_and_slide()
	
func shoot(projectile : PackedScene) -> void:
	print("Shooting")
	var proj : Projectile = projectile.instantiate() as Projectile
	proj.set_attributes(last_aim_dir, position)
	root.add_child(proj)
