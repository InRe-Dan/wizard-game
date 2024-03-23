class_name FrozenEffect extends Effect

@export var apply_immunity : bool = false
@export var permanent : bool = false

var particle_scene : PackedScene = preload("res://particles/frozen_particles.tscn")
var buildup : float = 0
var particles : GPUParticles2D

func _ready() -> void:
	is_visible = false
	icon = preload("res://assets/ice_icon.png")
	effect_name = "Frozen!"
	effect_description = "Movement is hindered!"
	particles = particle_scene.instantiate()
	particles.emitting = false
	add_child(particles)
	

func _process(delta : float) -> void:
	particles.global_position = get_parent().parent.global_position
	if permanent:
		buildup = 100
	if not apply_immunity:
		var entity : Entity = (get_parent() as EntityComponent).parent
		if FloorHandler.is_point_in_ice(entity.global_position):
			buildup -= min(delta / 10, buildup)
		elif buildup > 0.0:
			buildup -= min(delta, buildup)
		if buildup > 1 and not is_visible:
			is_visible = true
			updated.emit(self)
			particles.emitting = true
		if buildup < 1 and is_visible:
			is_visible = false
			updated.emit(self)
			particles.emitting = false
		effect_description = "Movement is hindered for " +str(buildup - 1)+"s."
		updated.emit(self)

func handle_event(event : Event) -> Event:
	if event is AddEffectEvent:
		var effect_event : AddEffectEvent = event as AddEffectEvent
		if effect_event.effect is FrozenEffect:
			var effect : FrozenEffect = effect_event.effect as FrozenEffect
			if effect.apply_immunity:
				apply_immunity = true
			else:
				buildup += effect.buildup
			return null
		elif effect_event.effect is FireEffect:
			buildup -= (effect_event.event as FireEffect).buildup
	if event is AttemptMoveEvent:
		event.acceleration_multiplier = min(event.acceleration_multiplier, event.acceleration_multiplier / buildup)
	return event
