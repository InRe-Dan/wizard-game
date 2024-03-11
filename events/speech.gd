class_name SpeechEvent extends Event

var text : String
var color : Color

func _init(text : String, color : Color) -> void:
	type = types.speech
	self.text = text
	self.color = color
