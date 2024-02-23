class_name AttemptMoveEvent extends Event

var direction : Vector2
var acceleration_multiplier : float = 1.0

func _init(direction : Vector2) -> void:
	type = types.attempt_move
	self.direction = direction
