class_name SpawnParticlesAction extends Action

@export var particles : PackedScene
@export var distance : float = 0

func _init(scene : PackedScene = null) -> void:
	if not particles:
		if scene:
			particles = scene

func _ready() -> void:
	description = ""
	expected_cooldown = 0

func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	var instance : GPUParticles2D = particles.instantiate()
	instance.global_position = target.global_position
	if not direction.is_equal_approx(Vector2.ZERO):
		(instance.process_material as ParticleProcessMaterial).direction = Vector3(direction.normalized().x, direction.normalized().y, 0)
		instance.global_position += direction.normalized() * distance
	target.get_tree().get_first_node_in_group("level").add_child(instance)
	instance.emitting = true
	instance.one_shot = true
	instance.finished.connect(instance.queue_free)
	finished.emit()

