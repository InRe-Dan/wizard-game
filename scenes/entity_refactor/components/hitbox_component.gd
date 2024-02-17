class_name HitboxComponent extends EntityComponent


func _ready() -> void:
	for child : Area2D in get_children():
		child.area_entered.connect(_on_area_entered)


func _process(delta : float) -> void:
	pass
	
func receive_signal(emitter : Entity, event : Event) -> Event:
	return event
	
func _on_area_entered(area : Area2D) -> void:
	print(parent.name, "hit", area.get_parent().get_parent())
