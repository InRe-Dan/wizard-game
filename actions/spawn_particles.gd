class_name SpawnParticlesAction extends Action

@export var particles : GPUParticles2D

func _ready() -> void:
	description = "?"
	expected_cooldown = 0

func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	particles.reparent(get_tree().get_first_node_in_group("level"))
	particles.global_position = target.global_position
	particles.emitting = true
	particles.one_shot = true
	particles.finished.connect(particles.queue_free)

