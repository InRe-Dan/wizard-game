extends EntityComponent

@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D
@onready var avoidance_vision : AvoidanceVision = $AvoidanceVision

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var target : Entity = get_tree().get_first_node_in_group("players") as Entity
	if target:
		var dir : Vector2 = find_direction_to(target.global_position).normalized()
		parent.distribute_signal(InputMoveEvent.new(dir))

func find_direction_to(global_pos : Vector2) -> Vector2:
	navigation_agent.target_position = global_pos
	if navigation_agent.is_navigation_finished():
		return Vector2()

	var current_agent_position: Vector2 = parent.global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	var navigation_direction : Vector2 = current_agent_position.direction_to(next_path_position)
	
	# Working out where to actually go
	return (0.5 * navigation_direction + 0.5 * avoidance_vision.sum)
