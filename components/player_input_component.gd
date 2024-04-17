class_name PlayerInputComponent extends EntityComponent

var focus : bool = true
var move : Vector2

var keyboard_controls = false
@onready var reticle : Sprite2D = $Reticle
@onready var cooldown : TextureProgressBar = $Reticle/TextureProgressBar
var last_controller_direction : Vector2


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
	if event is InputEventKey:
		keyboard_controls = true
	elif event is InputEventMouseMotion:
		if (event as InputEventMouseMotion).velocity.length() > 0.1:
			keyboard_controls = true
	elif event is InputEventJoypadButton:
		keyboard_controls = false
	elif event is InputEventJoypadMotion:
		if (event as InputEventJoypadMotion).axis_value > 0.9:
			keyboard_controls = false

	move = Input.get_vector("left", "right", "up", "down").normalized();
	var aim_dir : Vector2 = (get_global_mouse_position() - global_position).normalized()
	if not keyboard_controls:
		aim_dir = Input.get_vector("aimleft", "aimright", "aimup", "aimdown")
		if aim_dir.length() < 0.1:
			aim_dir = move
			if aim_dir.length() < 0.1:
				aim_dir = last_controller_direction
				if aim_dir.length() < 0.1:
					aim_dir = Vector2.UP
		aim_dir = aim_dir.normalized()
		last_controller_direction = aim_dir
		
	if event.is_pressed() or (event is InputEventMouseButton):
		if Input.is_action_pressed("shoot"):
			parent.distribute_signal(InputCommand.new(InputCommand.Commands.use, aim_dir))
		if event.is_action_pressed("discard"):
			parent.distribute_signal(InputCommand.new(InputCommand.Commands.consume, aim_dir))
		if event.is_action_pressed("cycleforward"):
			parent.distribute_signal(InputCommand.new(InputCommand.Commands.cyclef, aim_dir))
		if event.is_action_pressed("cyclebackward"):
			parent.distribute_signal(InputCommand.new(InputCommand.Commands.cycleb, aim_dir))
		if event.is_action_pressed("ability"):
			parent.distribute_signal(InputCommand.new(InputCommand.Commands.dash, aim_dir))
		if event.is_action_pressed("interact"):
			parent.distribute_signal(InputCommand.new(InputCommand.Commands.interact, aim_dir))

func _process(delta : float) -> void:
	var inventory : InventoryComponent = parent.get_children().filter(func f(x : Node) -> bool: return x is InventoryComponent).front()
	if inventory:
		cooldown.value = inventory.get_item_cooldown_progress()
	if keyboard_controls:
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_HIDDEN)
		reticle.visible = true
		parent.looking_at = get_global_mouse_position()
		# reticle.global_position = global_position + global_position.direction_to(parent.looking_at).normalized() * 48
		reticle.global_position = get_global_mouse_position()
	else:
		DisplayServer.mouse_set_mode(DisplayServer.MOUSE_MODE_CONFINED_HIDDEN)
		var aim_vec : Vector2 = Input.get_vector("aimleft", "aimright", "aimup", "aimdown")
		if aim_vec.length() < 0.2:
			aim_vec = Input.get_vector("left", "right", "up", "down")
		parent.looking_at = global_position + 180 * aim_vec
		if parent.looking_at.distance_to(global_position) < 24:
			reticle.visible = false
		else:
			reticle.visible = true
		reticle.position = aim_vec * 48
	reticle.global_position = round(reticle.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if move.length() > 0.1:
		parent.distribute_signal(InputMoveEvent.new(move))

func receive_signal(event : Event) -> Event:
	return event

