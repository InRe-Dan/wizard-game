extends EntityComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func receive_signal(entity : Entity, event : Event) -> Event:
	return event

func on_area_entered(area : Area2D) -> void:
	print(parent.name, "got hurt!")
