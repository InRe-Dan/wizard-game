extends EntityComponent

@export var trail_lifetime : float = 1.0
@export var radius : float = 30
@export_enum("Ice", "Water", "Fire") var type : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta : float) -> void:
	match type:
		0:
			FloorHandler.add_ice(global_position, radius)
		1:
			FloorHandler.add_water(global_position, radius)
		2:
			FloorHandler.add_fire(global_position, radius)

func receive_signal(event : Event) -> Event:
	return event
