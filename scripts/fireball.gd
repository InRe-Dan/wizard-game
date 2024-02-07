class_name Fireball extends Projectile

@export var texture : Texture2D

var destroyed : bool = false
@onready var collision_timer : Timer = $CollisionDespawnTimer
@onready var ray : RayCast2D = $Ray
@onready var sprite : Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	super(delta)

# Hitting a body like a tilemap or a CharacterBody
func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body as CharacterBody2D):
		if ((body as CharacterBody2D).collision_layer & 4) and not team == Team.Player:
			print("Hit player")
			(body as Player).hit(self)
			collide()
	elif (body as TileMap):
		collide()

# Probably hitting a hurtbox here
func _on_area_2d_area_entered(area: Area2D) -> void:
	if (area.collision_layer & 64) and team == Team.Player:
		(area.get_parent() as Enemy).hit(self)
		collide()
		print("Hit enemy")
	elif (area.collision_layer & 4) and not team == Team.Player:
		print("Hit player")
		(area.get_parent() as Player).hit(self)
		collide()
	elif (area.collision_layer == 128):
		(area.get_parent() as FloorEffect).apply_fire()

func collide() -> void:
	$PointLight2D.energy = 1.5
	get_tree().create_tween().tween_property($PointLight2D, "energy", 0.0, 0.5)
	sprite.hide()
	$GPUParticles2D.emitting = true
	$Area2D.queue_free()
	velocity = 0
	destroyed = true
	collision_timer.start()
