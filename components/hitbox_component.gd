class_name HitboxComponent extends EntityComponent

@export var damage : DamageData = DamageData.new()

func _ready() -> void:
	for child : Area2D in get_children():
		child.area_entered.connect(_on_area_entered)


func _process(delta : float) -> void:
	pass
	
func receive_signal(event : Event) -> Event:
	return event
	
func _on_area_entered(area : Area2D) -> void:
	var entity_hit : Entity = area.get_parent().get_parent() as Entity
	if not entity_hit:
		push_error("Hitbox hit something weird!")
	if entity_hit == (get_parent() as Entity).creator:
		return
	parent.distribute_signal(HasHitEvent.new(entity_hit, damage))
	print(parent.name, " hit ", area.get_parent().get_parent().name)
