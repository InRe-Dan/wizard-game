class_name CustomEvent extends Event

var identifier : String
var properties : Ditionary

func _init(id : string, dict : Dictionary) -> void:
	type = types.custom
	identifier = id
  properties = dict