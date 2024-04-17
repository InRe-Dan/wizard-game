class_name EntitySpawner extends Entity

@onready var emitter : GPUParticles2D = $GPUParticles2D
@onready var emitter_mat : ParticleProcessMaterial = emitter.process_material.duplicate() as ParticleProcessMaterial
@onready var subemitter : GPUParticles2D = $GPUParticles2D2
@onready var subemitter_mat : ParticleProcessMaterial = subemitter.process_material.duplicate() as ParticleProcessMaterial
@onready var flourish : GPUParticles2D = $Flourish

var entity : EntityResource
var delay : float

func spawn() -> void:
	var e : Entity = entity.make_entity()
	e.global_position = global_position
	add_sibling(e)
	flourish.emitting = true
	flourish.finished.connect(queue_free)
	print(emitter_mat.emission_shape_scale)
	
func do() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_interval(delay + 1.5)
	tween.set_parallel(true)
	tween.tween_property(emitter, "amount_ratio", 1, 1)
	tween.tween_property(emitter_mat, "tangential_accel_min", 10, 1)
	tween.set_parallel(false)
	tween.tween_interval(1)
	tween.tween_callback(spawn)
	tween.tween_property(emitter, "modulate:a", 0, 3)

func _ready() -> void:
	super()
	if not entity:
		push_error("Spawner made with no entity.")
	do()

func distribute_signal(event : Event) -> void:
	super(event)

