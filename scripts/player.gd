class_name Player extends CharacterBody2D

@export var low_damping_speed : float = 5000
@export var max_speed : float = 1000
@export var acceleration : float = 1000
@export var damping : float = 5
@export var ice_acceleration : float = 50
@export var dash_speed : float = 200

@onready var inventory : Inventory = $Inventory
@onready var animation : AnimatedSprite2D = $Animation
@onready var root : Node2D = get_tree().get_first_node_in_group("main")
@onready var bounding_box : Area2D = $BoundingBox
@onready var dash_cooldown : Timer = $DashCooldown
@onready var dash_cooldown_bar : EntityBar = $DashBar

var last_aim_dir : Vector2
var move : Vector2
var iceAreasIntersected : int = 0
var dialogue_scene : PackedScene = preload("res://scenes/dialogue.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var globals : Node = get_node("/root/Globals")
	globals.player = self

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	dash_cooldown_bar.update_bar(1 - dash_cooldown.time_left / dash_cooldown.wait_time)
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
		var mouse : Vector2 = get_global_mouse_position()
		last_aim_dir = mouse - position
		last_aim_dir = last_aim_dir.normalized()
		inventory.use_selected(self)
	if Input.is_action_just_pressed("shoot"):
		inventory.use_selected(self)
	if Input.is_action_just_pressed("ability"):
		dash()
	
	
	if Input.is_action_just_pressed("cycleforward"):
		inventory.next()
	if Input.is_action_just_pressed("cyclebackward"):
		inventory.prev()
		
func _physics_process(delta: float) -> void:
		if not bounding_box.get_overlapping_areas().any(func isIcy(area : Area2D) -> bool: return area.collision_layer & 128
		):
			velocity += acceleration * delta * move
			# scale damping by how far above the speed limit we are
			velocity *= 1. / (1. + max(damping, damping * (velocity.length() / low_damping_speed)) * delta)
		else:
			velocity += ice_acceleration * delta * move
		velocity = velocity.limit_length(max_speed)
		var collision : KinematicCollision2D = move_and_collide(velocity * delta)
		if collision:
			velocity = velocity.slide(collision.get_normal())
	
func shoot(projectile : PackedScene) -> void:
	var proj : Projectile = projectile.instantiate() as Projectile
	say("Eat this!")
	proj.set_attributes(last_aim_dir, position, Projectile.Team.Player)
	root.add_child(proj)

func say(text : String) -> void:
	var dialogue : Dialogue = dialogue_scene.instantiate() as Dialogue
	add_child(dialogue)
	dialogue.position = $DialoguePoint.position
	dialogue.set_parameters(text)
	
func dash() -> void:
	if dash_cooldown.is_stopped():
		velocity += move.normalized() * dash_speed
		dash_cooldown.start()
	
func hit(proj : Projectile) -> void:
	say("Ouch")
	
