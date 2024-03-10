class_name BeenInteractedEvent extends Event

var interacter : Entity

func _init(interacter : Entity) -> void:
	type = types.been_interacted
	self.interacter = interacter
