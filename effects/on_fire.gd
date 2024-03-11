extends Effect

var buildup : float = 0
@export var seconds_threshold : float = 0.5
@export var immunity : float = 0
@export var tick_damage : DamageData

func _init() -> void:
	pass

func _process(delta : float) -> void:
	print(buildup)
	var entity : Entity = (get_parent() as EntityComponent).parent
	if FloorHandler.is_point_in_fire(entity.global_position):
		buildup += delta
	elif buildup > 0.0:
		buildup -= min(delta * 2, buildup)
	if buildup > 1.0 and immunity < 0.01:
		entity.distribute_signal(TakeDamageEvent.new(tick_damage, Vector2.ZERO))
		immunity = 0.5
	if immunity > 0:
		immunity -= delta

func handle_event(event : Event) -> Event:
	return event

