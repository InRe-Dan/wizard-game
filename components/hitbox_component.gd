class_name HitboxComponent extends EntityComponent

@export var immunity_duration : float = 0.5
@export var hitbox : Area2D
@export var raycast : RayCast2D
	
var entities_hit : Array[Entity]
var immunity_durations : Array[float]

var hitting : Array[Area2D]

@export var damage : DamageData = DamageData.new()

func _ready() -> void:
	if raycast:
		raycast.hit_from_inside = true

func _process(delta : float) -> void:
	# awful stuff
	var i : int = 0
	while i < entities_hit.size():
		if not is_instance_valid(entities_hit[i]):
			entities_hit.remove_at(i)
			immunity_durations.remove_at(i)
			continue
		var entity : Entity = entities_hit[i]
		if immunity_durations[i] > 0.0:
			immunity_durations[i] -= delta
		if immunity_durations[i] < 0.0:
			entities_hit.remove_at(i)
			immunity_durations.remove_at(i)
		i += 1
	for area : Area2D in hitbox.get_overlapping_areas():
		var entity_hit : Entity = area.get_parent().get_parent() as Entity
		if not entity_hit:
			push_error("Hitbox hit something weird!")
		if entity_hit.team == (get_parent() as Entity).team and parent.team != EntityResource.EntityTeam.Any:
			continue
		if raycast:
			raycast.target_position = raycast.to_local(entity_hit.global_position)
			if raycast.is_colliding():
				print("Ignored")
				continue
		parent.distribute_signal(HasHitEvent.new(entity_hit, damage))

func receive_signal(event : Event) -> Event:
	match event.type:
		Event.types.has_hit:
			var hEvent : HasHitEvent = event as HasHitEvent
			if entities_hit.has(hEvent.target):
				event.queue_free()
				return DamageNullifiedEvent.new()
			entities_hit.append(hEvent.target)
			immunity_durations.append(immunity_duration)
	return event
	

