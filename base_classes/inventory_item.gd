@icon("res://assets/editor_icons/engine/Override.svg")
class_name InventoryItem extends Node

var resource : ItemResource

var description : String
var uses : int = 3
var awaited_signal_count : int
var expected_cooldown : float
var time_since_used : float = INF

func _ready() -> void:
	expected_cooldown = 0
	for action : Action in get_children():
		action.finished.connect(_on_action_finish)
		expected_cooldown = max(action.expected_cooldown, expected_cooldown)
		if description != "":
			description += action.description + ". "
	
	
func _process(delta: float) -> void:
	time_since_used += delta

func is_ready() -> bool:
	return awaited_signal_count == 0

func _on_action_finish() -> void:
	awaited_signal_count -= 1

# Returns whether or not the item has been consumed
func use(owner : Entity, direction : Vector2) -> bool:
	if not is_ready():
		return false
	
	time_since_used = 0
	if resource.limited_use:
		uses -= 1
	for action : Action in get_children():
		awaited_signal_count += 1
		action.do(owner, null, direction)
	if uses == 0:
		return true
	return false
