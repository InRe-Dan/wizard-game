class_name InputUseEvent extends Event

var target : Vector2

func _init(target : Vector2) -> void:
	type = types.inputattack
	self.target = target
