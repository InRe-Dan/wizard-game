class_name HasInteractedEvent extends Event

var target : Entity
var dir_to : Vector2

func _init(target : Entity, dir_to : Vector2) -> void:
	type = types.been_interacted
	self.target = target
	self.dir_to = dir_to
