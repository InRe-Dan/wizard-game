class_name InputCommand extends Event

enum Commands {attack, heal, dash, use}
var command : Commands
var direction : Vector2

# Called when the node enters the scene tree for the first time.
func _init(command : Commands, direction : Vector2) -> void:
	type = Event.types.inputcommand
	self.command = command
	self.direction = direction
