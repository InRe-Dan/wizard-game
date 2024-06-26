extends Entity

var sound : AudioStream = preload("res://assets/sounds/splash.wav")
@export var particle_material : ParticleProcessMaterial
@export var particle_texture : Texture2D
var collision_vel : Vector2


func distribute_signal(event : Event) -> void:
	if event is CollisionEvent:
		collision_vel = - (event as CollisionEvent).velocity
	if event is DeathEvent:
		AudioHandler.play_sound(sound, global_position)
		var particles : GPUParticles2D = GPUParticles2D.new()
		particles.one_shot = true
		particles.emitting = true
		particles.explosiveness = 1
		particles.amount = 400
		particles.lifetime = 2
		particles.finished.connect(particles.queue_free)
		particle_material.direction = Vector3(collision_vel.normalized().x, collision_vel.normalized().y, 0)
		particles.process_material = particle_material
		particles.texture = particle_texture
		particles.material = CanvasItemMaterial.new()
		particles.material.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD
		particles.z_index = 3
		var material : ParticleProcessMaterial = particles.process_material
		get_tree().get_first_node_in_group("main").add_child(particles)
		particles.global_position = global_position
		FloorHandler.add_water(global_position, 32)
	super(event)
