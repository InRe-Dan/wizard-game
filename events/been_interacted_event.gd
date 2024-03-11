class_name BeenInteractedEvent extends Event

var interacter : Entity
var dir_from : Vector2

func _init(interacter : Entity, dir_from : Vector2) -> void:
	type = types.been_interacted
	self.interacter = interacter
	self.dir_from = dir_from
