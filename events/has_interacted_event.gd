class_name HasInteractedEvent extends Event

var target : Entity

func _init(target : Entity) -> void:
	type = types.been_interacted
	self.target = target
