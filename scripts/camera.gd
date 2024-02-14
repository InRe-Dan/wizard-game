extends Camera2D

@onready var target : Entity = get_tree().get_first_node_in_group("players") as Entity

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	return
	global_position = round(target.global_position)
