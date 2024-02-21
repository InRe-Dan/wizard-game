class_name SpeechEvent extends Event

var text : String

func _init(text : String) -> void:
	type = types.speech
	self.text = text
