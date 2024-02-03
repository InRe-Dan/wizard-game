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

# Hitting a body like a tilemap
func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Hit body")
	collide()

# Probably hitting a hitbox here
func _on_area_2d_area_entered(area: Area2D) -> void:
	print("Hit area")
	if (area.collision_layer & 64):
		print(area.get_parent())
		(area.get_parent() as Enemy).hit(self)
	collide()

func collide() -> void:
	sprite.hide()
	$GPUParticles2D.emitting = true
	$Area2D.queue_free()
	velocity = 0
	destroyed = true
	collision_timer.start()