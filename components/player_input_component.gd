class_name PlayerInputComponent extends EntityComponent

var focus : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _notification(what : Variant) -> void:
	match what:
		NOTIFICATION_WM_WINDOW_FOCUS_IN:
			focus = true
		NOTIFICATION_WM_WINDOW_FOCUS_OUT:
			focus = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not focus:
		return
	var move : Vector2 = Input.get_vector("left", "right", "up", "down").normalized();
	var aim_dir : Vector2 = Input.get_vector("aimleft", "aimright", "aimup", "aimdown").normalized();
	aim_dir = (get_global_mouse_position() - global_position).normalized()
	if move.length() > 0.1:
		parent.distribute_signal(InputMoveEvent.new(move))
	if Input.is_action_just_pressed("shoot"):
		parent.distribute_signal(InputCommand.new(InputCommand.Commands.use, aim_dir))
	if Input.is_action_just_pressed("cycleforward"):
		parent.distribute_signal(InputCommand.new(InputCommand.Commands.cyclef, aim_dir))
	if Input.is_action_just_pressed("cyclebackward"):
		parent.distribute_signal(InputCommand.new(InputCommand.Commands.cycleb, aim_dir))
	if Input.is_action_just_pressed("ability"):
		parent.distribute_signal(InputCommand.new(InputCommand.Commands.dash, aim_dir))
	if Input.is_action_just_pressed("interact"):
		parent.distribute_signal(InputCommand.new(InputCommand.Commands.interact, aim_dir))

func receive_signal(event : Event) -> Event:
	return event

