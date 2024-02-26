extends Entity

func _physics_process(delta : float) -> void:
	FloorHandler.melt_ice(global_position, 16)
	super(delta)
