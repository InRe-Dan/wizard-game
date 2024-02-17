extends EntityComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child : Area2D in get_children():
		child.area_entered.connect(_on_area_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func receive_signal(entity : Entity, event : Event) -> Event:
	return event

func _on_area_entered(area : Area2D) -> void:
	print(parent.name, "got hurt!")
