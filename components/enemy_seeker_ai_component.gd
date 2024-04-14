extends EntityComponent

@export var detection_radius : float = 96
@export var attack_range : float = 16
@export var attack_windup : float = 0.5
@export var attack_cooldown : float = 1
@export var show_states : bool = false
@export var desired_distance : float = 48

@onready var navigation_agent : NavigationAgent2D = $NavigationAgent2D
@onready var los : RayCast2D = $LineOfSight
@onready var state_chart : StateChart = $StateChart
@onready var state_label : Label = $Label

var last_target_position : Vector2 = Vector2.ZERO

var bored_timer : float
var walk_direction : Vector2
var target : Entity
var time_since_attacked : float
var time_since_in_range : float
var last_objective_position : Vector2

func receive_signal(event : Event) -> Event:
	if event is BeenHitEvent:
		if event.dealer.team == EntityResource.EntityTeam.Player:
			state_chart.send_event("got_hit")
			los.target_position = (event.dealer.global_position - global_position).normalized() * 1000
			last_target_position = los.get_collision_point()
	return event

func attack(target_global_position : Vector2) -> void:
	if time_since_attacked > attack_cooldown and time_since_in_range > attack_windup:
		time_since_attacked = 0
		parent.distribute_signal(InputCommand.new(InputCommand.Commands.use, parent.global_position.direction_to(target_global_position)))

func _process(delta: float) -> void:
	time_since_attacked += delta
	if show_states:
		var states : Array = []
		var states_to_explore : Array = []
		states_to_explore.append_array(state_chart._state.get_children())
		while not states_to_explore.is_empty():
			var state : State = states_to_explore.front() as State
			if state:
				states_to_explore.append_array(state.get_children())
				if (states_to_explore.front())._state_active:
					states.append(state.name)
			states_to_explore.remove_at(0)
		var label_text : String = ""
		for state_name : String in states:
			label_text += state_name + "\n"
		state_label.text = label_text


func find_direction_to(global_pos : Vector2) -> Vector2:
	if (global_pos - last_target_position).length() < 16 or true:	
		navigation_agent.target_position = global_pos
		last_objective_position = global_pos

	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var navigation_direction : Vector2 = parent.global_position.direction_to(next_path_position)
	# Working out where to actually go
	return navigation_direction

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
	var to_target : Vector2 = target.global_position - global_position
	var desired_position : Vector2 = target.global_position - to_target.normalized() * desired_distance
	var dir : Vector2 = find_direction_to(desired_position).normalized()
	parent.distribute_signal(InputMoveEvent.new(dir))
	if parent.global_position.distance_to(target.global_position) < attack_range:
		time_since_in_range += delta
		attack(target.global_position)
	else:
		time_since_in_range = 0


func _on_seeking_state_physics_processing(delta: float) -> void:
	if not is_instance_valid(target):
		state_chart.send_event("lost_sight")
		return
	if not has_los_to(target.global_position):
		state_chart.send_event("lost_sight")
	else:
		last_target_position = target.global_position

func _on_searching_state_physics_processing(delta: float) -> void:
	parent.distribute_signal(InputMoveEvent.new(find_direction_to(last_target_position)))
	if global_position.distance_to(last_target_position) < 16:
		state_chart.send_event("reached_target")


func _on_following_state_entered() -> void:
	time_since_in_range = 0
