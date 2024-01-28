class_name Fireball extends Projectile

@export var damage : float = 50
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
	ray.target_position = position + velocity * direction # Replace with function body.
	if not destroyed:
		if ray.is_colliding():
			if (ray.get_collision_point() - position).length() < 5:
				collide()
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	collide()

func collide() -> void:
	sprite.hide()
	$GPUParticles2D.emitting = true
	velocity = 0
	destroyed = true
	collision_timer.start()