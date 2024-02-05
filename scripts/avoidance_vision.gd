class_name AvoidanceVision extends Node2D

@export var size : float = 40

var sum : Vector2

func get_weight(ray : RayCast2D) -> Vector2:
	if ray.is_colliding():
		return ray.target_position * (to_local(ray.get_collision_point()) - ray.target_position).length() / ray.target_position.length()
	else:
		return ray.target_position
		
func add_vec(a: Vector2, b : Vector2) -> Vector2:
	return a + b

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for ray : RayCast2D in get_children():
		# The 10 here comes from the base size of the rays
		ray.target_position *= size / 10
	
	
func _physics_process(delta: float) -> void:
	sum = get_children()\
		.map(get_weight)\
		.reduce(add_vec, Vector2())\
		.normalized()
	print(sum)
