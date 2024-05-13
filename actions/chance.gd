class_name ChanceAction extends Action

@export var chance : float = 0.5

var actions_not_done : int = 0

func _init(MAKE_SURE_THESE_HAVE_NULL_DEFAULTS : Object = null) -> void:
	pass
func _ready() -> void:
	description = ""
	expected_cooldown = 0
	for child : Action in get_children():
		expected_cooldown = max(expected_cooldown, child.expected_cooldown)

func decrement() -> void:
	actions_not_done -= 1
	if actions_not_done == 0:
		finished.emit()

func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	expected_cooldown = 0
	if randf() < 0.5 and get_child_count():
		for child : Action in get_children():
			actions_not_done += 1
			child.do(target, secondary, direction)
			child.finished.connect(decrement)
			expected_cooldown = max(expected_cooldown, child.expected_cooldown)
	else:
		finished.emit()

