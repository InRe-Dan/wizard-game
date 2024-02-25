extends EntityComponent

@export var detection_radius : float = 96

@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D
@onready var avoidance_vision : AvoidanceVision = $AvoidanceVision
@onready var los : RayCast2D = $LineOfSight
@onready var state_chart : StateChart = $StateChart

var last_target_position : Vector2 = Vector2.ZERO

var bored_timer : float
var walk_direction : Vector2
var target : Entity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func find_direction_to(global_pos : Vector2) -> Vector2:
	if (global_pos - last_target_position).length() < 100:	
		navigation_agent.target_position = global_pos
		last_target_position = global_pos

	if navigation_agent.is_navigation_finished():
		return Vector2()

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var navigation_direction : Vector2 = parent.global_position.direction_to(next_path_position)
	
	# Working out where to actually go
	return (0.5 * navigation_direction + 0.5 * avoidance_vision.sum)

func has_los_to(global_pos : Vector2) -> bool:
	los.target_position = to_local(global_pos)
	return not los.is_colliding()


func _on_walking_state_entered() -> void:
	bored_timer = 0.1 + 0.4 * randf()
	walk_direction = Vector2.RIGHT.rotated(randf() * TAU)

func _on_walking_state_physics_processing(delta: float) -> void:
	parent.distribute_signal(InputMoveEvent.new(walk_direction))

func _on_idle_state_physics_processing(delta: float) -> void:
	bored_timer -= delta
	if bored_timer < 0:
		state_chart.send_event("bored")
	var targets : Array = get_tree().get_nodes_in_group("players")
	for entity : Entity in targets:
		if has_los_to(entity.global_position) and (entity.global_position - global_position).length() < detection_radius:
			state_chart.send_event("player_seen")
			target = entity

func _on_standing_state_entered() -> void:
		bored_timer = 2 + 3 * randf()


func _on_following_state_physics_processing(delta: float) -> void:
	var dir : Vector2 = find_direction_to(target.global_position).normalized()
	parent.distribute_signal(InputMoveEvent.new(dir))


func _on_seeking_state_physics_processing(delta: float) -> void:
	if not has_los_to(target.global_position):
		state_chart.send_event("lost_sight")

func _on_searching_state_entered() -> void:
	last_target_position = target.global_position

func _on_searching_state_physics_processing(delta: float) -> void:
	parent.distribute_signal(InputMoveEvent.new(global_position.direction_to(last_target_position)))
	if global_position.distance_to(last_target_position) < 16:
		state_chart.send_event("reached_target")

