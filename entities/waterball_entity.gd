extends Entity

var sound : AudioStream = preload("res://assets/sounds/splash.wav")
@export var particle_material : ParticleProcessMaterial
@export var particle_texture : Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func distribute_signal(event : Event) -> void:
	if event.type == Event.types.death:
		AudioHandler.play_sound(sound, global_position)
		var particles : GPUParticles2D = GPUParticles2D.new()
		particles.one_shot = true
		particles.emitting = true
		particles.explosiveness = 1
		particles.amount = 400
		particles.lifetime = 2
		particles.finished.connect(particles.queue_free)
		particle_material.direction = Vector3(velocity.normalized().x, velocity.normalized().y, 0)
		particles.process_material = particle_material
		particles.texture = particle_texture
		particles.material = CanvasItemMaterial.new()
		particles.material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		var material : ParticleProcessMaterial = particles.process_material
		get_tree().get_first_node_in_group("main").add_child(particles)
		particles.global_position = global_position
	super(event)
