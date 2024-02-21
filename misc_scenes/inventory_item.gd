class_name InventoryItem extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func use(owner : Entity, direction : Vector2) -> void:
	for action : Action in get_children():
		action.do(owner, null, direction)
