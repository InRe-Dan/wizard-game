class_name CollisionEvent extends Event

var collision : KinematicCollision2D

func _init(collision : KinematicCollision2D) -> void:
	type = Event.types.collision
	self.collision = collision

