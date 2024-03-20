class_name HitboxComponent extends EntityComponent

@export var immunity_duration : float = 0.5
	
var immunity_times : Dictionary

@export var damage : DamageData = DamageData.new()

func _ready() -> void:
	for child : Area2D in get_children():
		child.area_entered.connect(_on_area_entered)

func _process(delta : float) -> void:
	for entity : WeakRef in immunity_times:
		if immunity_times[entity] > 0.0:
			immunity_times[entity] -= delta
		if immunity_times[entity] < 0.0:
			immunity_times.erase(entity)

func receive_signal(event : Event) -> Event:
	match event.type:
		Event.types.has_hit:
			var hEvent : HasHitEvent = event as HasHitEvent
			if immunity_times.has(weakref(hEvent.target)):
				if immunity_times[weakref(hEvent.target)] > 0.0:
					return DamageNullifiedEvent.new()
			immunity_times[weakref(hEvent.target)] = immunity_duration
	return event

	
func _on_area_entered(area : Area2D) -> void:
	var entity_hit : Entity = area.get_parent().get_parent() as Entity
	if not entity_hit:
		push_error("Hitbox hit something weird!")
	if entity_hit.team == (get_parent() as Entity).team and parent.team != EntityResource.EntityTeam.Any:
		return
	parent.distribute_signal(HasHitEvent.new(entity_hit, damage))
