class_name InputMoveEvent extends Event

var direction : Vector2

func _init(direction : Vector2) -> void:
	self.type = Event.types.inputmove
	self.direction = direction
