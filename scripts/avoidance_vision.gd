class_name AvoidanceVision extends Node2D

@export var tolerance : float = 10

@onready var left : RayCast2D = $Left
@onready var center : RayCast2D = $Center
@onready var right : RayCast2D = $Right

var left_collision_point : Vector2
var center_collision_point : Vector2
var right_collision_point : Vector2
var targetDirection : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	# Not totally sure if this needs to be here or if the raycasts
	# are happy to update elsewhere. 
	global_rotation = targetDirection.angle() + PI/2
	left_collision_point = left.get_collision_point()
	center_collision_point = center.get_collision_point()
	right_collision_point = center.get_collision_point()

func getSuggestion() -> Vector2:
	# Find out how far along the raycasts there has been a collision
	var distance_to_left : float = (left_collision_point - global_position).length()
	var distance_to_center : float = (center_collision_point - global_position).length()
	var distance_to_right : float = (right_collision_point - global_position).length()
	# This vector should be roughly parallel to the collision object
	var right_to_left : Vector2 = (left_collision_point - right_collision_point)
	# If the center isn't colliding then left and right data are not very relevant
	# Tolerance level is so that we avoid constant side switching
	if center.is_colliding() and abs(distance_to_left - distance_to_right) > tolerance:
		# go parallel to the surface
		if distance_to_left > distance_to_right:
			# Go parallel upwards
			return right_to_left
		else:
			# Go parallel downwards
			return - right_to_left
	# These two cases are in case we are already moving parallel enough to the surface.
	elif left.is_colliding() and not right.is_colliding():
		return right_to_left
	elif right.is_colliding() and not left.is_colliding():
		return -right_to_left
	return targetDirection
