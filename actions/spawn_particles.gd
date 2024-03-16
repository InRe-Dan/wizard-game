class_name SpawnParticlesAction extends Action

@export var particles : PackedScene

func _init(scene : PackedScene = null) -> void:
	if not particles:
		if scene:
			particles = scene

func _ready() -> void:
	description = "?"
	expected_cooldown = 0

func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	var instance : GPUParticles2D = particles.instantiate()
	target.get_tree().get_first_node_in_group("level").add_child(instance)
	instance.global_position = target.global_position
	instance.emitting = true
	instance.one_shot = true
	instance.finished.connect(instance.queue_free)

