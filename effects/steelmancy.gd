class_name MetalmancyEffect extends Effect

var sword : EntityResource = preload("res://resources/entities/sword.tres")

func _init() -> void:
	icon = null
	effect_name = "Steelmancy"
	effect_description = "Your dagger is larger and more powerful!"

func _process(delta : float) -> void:
	pass
	
func handle_event(event : Event) -> Event:
	var proj_e : CreatedProjectileEvent = event as CreatedProjectileEvent
	if proj_e:
		if not proj_e.proj.resource.entity_name == "Knife":
			return event
		var entity : Entity = sword.make_entity()
		var action : SwingAction = proj_e.proj.get_parent() as SwingAction
		action.remove_child(proj_e.proj)
		action.add_child(entity)
		action.entity = entity
		entity.team = parent.team
		var new_event : CreatedProjectileEvent = CreatedProjectileEvent.new(entity)
		parent.distribute_signal(new_event)
		return null
	if event is AddEffectEvent:
		if (event as AddEffectEvent).effect is MetalmancyEffect:
			event.queue_free()
			return null
	return event

