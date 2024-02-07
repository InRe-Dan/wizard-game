class_name ExplorerAI extends EnemyAI

@onready var parent : Enemy = get_parent() as Enemy
@onready var player : Player = get_node("/root/Globals").player
@onready var state_chart : StateChart = $StateChart
@onready var state_label : Label = $Label


var stand_time : float
var walk_time : float
var walk_destination : Vector2
var player_last_seen : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _process(delta : float) -> void:
	var states : Array[String] = []
	var states_to_explore : Array[State] = []
	states_to_explore.append_array(state_chart._state.get_children() as Variant)
	while true:
		var state : State = states_to_explore.front() as State
		if state:
			states_to_explore.append_array(states_to_explore.front().get_children())
			if (states_to_explore.front() as State)._state_active:
				states.append(state.name)
			states_to_explore.remove_at(0)
		else:
			break
	var label_text : String = ""
	for state_name : String in states:
		label_text += state_name + "\n"
	state_label.text = label_text

func _on_following_state_physics_processing(delta: float) -> void:
	if not parent.has_los_to(player.global_position):
		state_chart.send_event("lost sight")
		return
	player_last_seen = player.global_position
	# Navigation code
	parent.go_to(player.global_position)
	parent.try_attack(player)
	

func _on_standing_state_physics_processing(delta: float) -> void:
	parent.go_to(parent.global_position)
	walk_time -= delta
	if walk_time < 0:
		state_chart.send_event("done standing")

func _on_walking_state_physics_processing(delta: float) -> void:
	stand_time -= delta
	if stand_time < 0:
		state_chart.send_event("done walking")
	parent.go_to(walk_destination)

func _on_searching_state_physics_processing(delta: float) -> void:
	if parent.go_to(player_last_seen):
		print("we out here")
		state_chart.send_event("reached position")


func _on_walking_state_entered() -> void:
	walk_destination = parent.global_position + Vector2.RIGHT.rotated(randf() * TAU) * 1000
	walk_time = 2 + randf() * 3.0



func _on_standing_state_entered() -> void:
	stand_time = 0.5 + randf() * 5.0


func _on_root_state_processing(delta: float) -> void:
	if parent.has_los_to(player.global_position):
		state_chart.send_event("seen player")
