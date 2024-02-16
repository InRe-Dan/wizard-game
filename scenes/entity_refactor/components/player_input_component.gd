class_name PlayerInputComponent extends EntityComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var move : Vector2 = Input.get_vector("left", "right", "up", "down");
	var aim_dir : Vector2 = Input.get_vector("aimleft", "aimright", "aimup", "aimdown");
	aim_dir = (get_global_mouse_position() - global_position).normalized()
	if move.length() > 0.1:
		parent.distribute_signal(parent, InputMoveEvent.new(move))
	if Input.is_action_just_pressed("shoot"):
		parent.distribute_signal(parent, InputCommand.new(InputCommand.Commands.use, aim_dir))
func receive_signal(emitter : Entity, event : Event) -> Event:
	return event

