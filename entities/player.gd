class_name Player extends Entity

var dash_cooldown_timer : float = 0.0

func _ready() -> void:
	super()
	Global.clear_score()

func _physics_process(delta: float) -> void:
	dash_cooldown_timer -= delta
	FloorHandler.clear_fog(global_position, 128)

func distribute_signal(event : Event) -> void:
	if event.type == event.types.take_damage:
		get_tree().get_first_node_in_group("camera").shake(0.3)
	elif event.type == event.types.inputcommand:
		var input : InputCommand = event as InputCommand
		if input.command == input.Commands.dash and dash_cooldown_timer <= 0.01:
			dash_cooldown_timer = 0.6
			velocity += last_move_input * 200
	if event is AddEffectEvent:
		var effect : Effect = (event as AddEffectEvent).effect
		if effect.resource:
			Global.announce_passive(effect.resource)
	super(event)
