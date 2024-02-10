class_name InputMoveEvent extends Event

var direction : Vector2
var type : Event.types = Event.types.inputmove

func _init(direction : Vector2) -> void:
	self.direction = direction
