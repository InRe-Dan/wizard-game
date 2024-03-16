extends Effect

var particle_scene : PackedScene = preload("res://particles/heal_particles.tscn")
var spawn_action : SpawnParticlesAction = SpawnParticlesAction.new(particle_scene)

func _init() -> void:
	is_visible = false
	icon = null
	effect_name = ""
	effect_description = ""
	
func handle_event(event : Event) -> Event:
	if event.type == event.types.healed:
		spawn_action.do(get_parent().parent)
	return event

