class_name EntitySpawner extends Entity

@onready var emitter : GPUParticles2D = $GPUParticles2D
@onready var emitter_mat : ParticleProcessMaterial = emitter.process_material as ParticleProcessMaterial
@onready var subemitter : GPUParticles2D = $GPUParticles2D2
@onready var subemitter_mat : ParticleProcessMaterial = subemitter.process_material as ParticleProcessMaterial
@onready var flourish : GPUParticles2D = $Flourish

var entity : EntityResource
var delay : float

var lifetime : float = 0

func spawn() -> void:
	print("Want to spawn: " + entity.entity_name)
	var e : Entity = entity.make_entity()
	e.global_position = global_position
	add_sibling(e)
	flourish.emitting = true
	flourish.finished.connect(queue_free)
	
func do() -> void:
	var tween : Tween = get_tree().create_tween()
	tween.tween_interval(1)
	tween.set_parallel()
	tween.tween_property(emitter_mat, "emission_ring_radius", 1, delay)
	tween.tween_property(emitter_mat, "mission_ring_inner_radius", 1, delay)
	tween.tween_property(emitter, "amount", 100, delay)
	tween.set_parallel(false)
	tween.tween_callback(spawn)

func _ready() -> void:
	super()
	if not entity:
		push_error("Spawner made with no entity.")
	do()

func _process(delta: float) -> void:
	lifetime += delta

func distribute_signal(event : Event) -> void:
	super(event)

