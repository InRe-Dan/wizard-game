class_name EffectContainerComponent extends EntityComponent

@export var initial_effects : Array[PassiveResource] = []

func _ready() -> void:
	for effect : PassiveResource in initial_effects:
		add_child(effect.make_effect())

func receive_signal(event : Event) -> Event:
	for effect : Node in get_children():
		event = effect.call("handle_event", event)
		if not event:
			return null

	if event:
		if event.type == event.types.add_effect:
			add_child((event as AddEffectEvent).effect) 
	return event
	


