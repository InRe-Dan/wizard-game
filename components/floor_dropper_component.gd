extends EntityComponent

@export var trail_lifetime : float = 1.0
@export var radius : float = 30
@export var despawn_in_opposing_element : bool = false
@export_enum("Ice", "Water", "Fire") var type : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta : float) -> void:
	match type:
		0:
			if not FloorHandler.is_point_in_fire(global_position):
				FloorHandler.add_ice(global_position, radius)
			elif despawn_in_opposing_element:
				parent.distribute_signal(DeathEvent.new())
		1:
			if not FloorHandler.is_point_in_ice(global_position):
				FloorHandler.add_water(global_position, radius)
			elif despawn_in_opposing_element:
				parent.distribute_signal(DeathEvent.new())
		2:
			if not FloorHandler.is_point_in_water(global_position):
				FloorHandler.add_fire(global_position, radius)
			elif despawn_in_opposing_element:
				parent.distribute_signal(DeathEvent.new())

func receive_signal(event : Event) -> Event:
	return event
