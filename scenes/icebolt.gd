class_name IceBolt extends Projectile

@export var damage : float = 50
@export var texture : Texture2D

var destroyed : bool = false
@onready var collision_timer : Timer = $CollisionDespawnTimer
@onready var ray : RayCast2D = $Ray

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	super(delta)
	ray.target_position = position + velocity * direction # Replace with function body.
	if ray.is_colliding():
		if (ray.get_collision_point() - position).length() < 0.3:
			collide()
		
func _on_area_2d_body_entered(body: Node2D) -> void:
	collide()

func collide() -> void:
	velocity = 0
	destroyed = true
	collision_timer.start()
