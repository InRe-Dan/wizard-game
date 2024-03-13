class_name PlayerInputComponent extends EntityComponent

var focus : bool = true
var move : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _notification(what : Variant) -> void:
	match what:
		NOTIFICATION_WM_WINDOW_FOCUS_IN:
			focus = true
		NOTIFICATION_WM_WINDOW_FOCUS_OUT:
			focus = false

func _unhandled_input(event: InputEvent) -> void:
	move = Input.get_vector("left", "right", "up", "down").normalized();
	var aim_dir : Vector2 = (get_global_mouse_position() - global_position).normalized()
	if event.is_pressed() or (event is InputEventMouseButton):
		if event.is_action_pressed("shoot"):
			parent.distribute_signal(InputCommand.new(InputCommand.Commands.use, aim_dir))
		if event.is_action_pressed("cycleforward"):
			parent.distribute_signal(InputCommand.new(InputCommand.Commands.cyclef, aim_dir))
		if event.is_action_pressed("cyclebackward"):
			parent.distribute_signal(InputCommand.new(InputCommand.Commands.cycleb, aim_dir))
		if event.is_action_pressed("ability"):
			parent.distribute_signal(InputCommand.new(InputCommand.Commands.dash, aim_dir))
		if event.is_action_pressed ("interact"):
			parent.distribute_signal(InputCommand.new(InputCommand.Commands.interact, aim_dir))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if move.length() > 0.1:
		parent.distribute_signal(InputMoveEvent.new(move))

func receive_signal(event : Event) -> Event:
	return event

