class_name ExplorerAI extends EnemyAI

@onready var parent : Enemy = get_parent() as Enemy
@onready var player : Player = get_node("/root/Globals").player
@onready var avoidance_vision : AvoidanceVision = $AvoidanceVision
@onready var state_chart : StateChart = $StateChart
@onready var state_label : Label = $StateInformation
@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D

var walk_destination : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_following_state_physics_processing(delta: float) -> void:
	if not parent.has_los_to(player.global_position):
		pass # state_chart.send_event("lost sight")

	# Navigation code
	navigation_agent.target_position = get_node("/root/Globals").player.global_position
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector2 = parent.global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()

	var navigation_direction : Vector2 = current_agent_position.direction_to(next_path_position)
	
	# Working out where to actually go
	parent.target_direction = 0.5 * navigation_direction\
					+ 0.5 * avoidance_vision.sum
	parent.velocity += parent.target_direction.normalized() * parent.acceleration * delta
	

func _on_standing_state_physics_processing(delta: float) -> void:
	pass

func _on_on_walk_start_taken() -> void:
	walk_destination = parent.global_position + Vector2.RIGHT.rotated(randf() * TAU) * 1000

func _on_walking_state_physics_processing(delta: float) -> void:
	parent.velocity += (parent.global_position - walk_destination).normalized() * parent.acceleration * delta

func _on_searching_state_physics_processing(delta: float) -> void:
	pass
