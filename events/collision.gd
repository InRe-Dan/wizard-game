class_name CollisionEvent extends Event

var collision : KinematicCollision2D
var velocity_lost : float
var velocity : Vector2
var entity : Entity

func _init(collision : KinematicCollision2D, velocity : Vector2, velocity_lost : float, entity : Entity) -> void:
	type = Event.types.collision
	self.collision = collision
	self.velocity_lost = velocity_lost
	self.velocity = velocity
	self.entity = entity
