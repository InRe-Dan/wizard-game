class_name ExplorerAI extends EnemyAI

@onready var parent : Enemy = get_parent() as Enemy
@onready var player : Player = get_node("/root/Globals").player
@onready var avoidance_vision : AvoidanceVision = $AvoidanceVision
@onready var state_chart : StateChart = $StateChart
@onready var state_label : Label = $StateInformation

var walk_destination : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_following_state_physics_processing(delta: float) -> void:
	if not parent.has_los_to(player.global_position):
		state_chart.send_event("lost sight")
	# weigh our previous target destination (which was influenced by the helper) with the suggestion
	parent.target_direction = 0.5 * (player.global_position - parent.global_position).normalized()\
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
