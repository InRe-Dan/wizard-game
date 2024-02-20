class_name HurtboxComponent extends EntityComponent
	
@export var immunity_duration : float = 0.5
	
var immunity_times : Dictionary


func _process(delta : float) -> void:
	for entity : Entity in immunity_times:
		if immunity_times[entity] > 0.0:
			immunity_times[entity] -= delta
		if immunity_times[entity] < 0.0:
			immunity_times.erase(entity)

func receive_signal(event : Event) -> Event:
	match event.type:
		Event.types.take_damage:
			var tEvent : TakeDamageEvent = event as TakeDamageEvent
			immunity_times[tEvent.dealer] = immunity_duration
		Event.types.been_hit:
			var hEvent : BeenHitEvent = event as BeenHitEvent
			if immunity_times.has(hEvent.dealer):
				if immunity_times[hEvent.dealer] > 0.0:
					return DamageNullifiedEvent.new()
	return event

