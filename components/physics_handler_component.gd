extends EntityComponent

@export var base_acceleration : float = 500
@export var base_damping : float = 5
@export var take_collision_damage : bool = true
@export var knockback_damage_min_speed : float = 150
@export var ice_acceleration_multiplier : float = 0.1
@export var ice_damping_multiplier : float = 0.01
@export var water_damping_multiplier : float = 1.5

var sound : AudioStream = preload("res://assets/sounds/thud.wav")
var last_move_processed : bool = true
var last_move_direction : Vector2
var last_move_acceleration_mult : float

func _physics_process(delta : float) -> void:
	var damp_factor : float = base_damping * delta
	var acceleration_factor : float = base_acceleration * last_move_acceleration_mult * delta
	if FloorHandler.is_point_in_ice(global_position):
		damp_factor *= ice_damping_multiplier
		acceleration_factor *= ice_acceleration_multiplier
	if FloorHandler.is_point_in_water(global_position):
		damp_factor *= water_damping_multiplier
	if not last_move_processed:
		last_move_processed = true
		parent.velocity += last_move_direction * acceleration_factor
	parent.velocity = parent.velocity / (1 + damp_factor)
	var collision : KinematicCollision2D = parent.move_and_collide(parent.velocity * delta)
	
	if collision:
		if parent.knockback_time - Time.get_ticks_msec() < parent.knockback_valid_timer * 1000:
			if knockback_damage_min_speed < parent.velocity.length() and take_collision_damage:
				var damage : DamageData = DamageData.new()
				damage.damage = floor(parent.velocity.length() / knockback_damage_min_speed)
				damage.damage_type = damage.DamageTypes.kinetic
				damage.knockback_velocity = parent.velocity.length() * 0.5
				AudioHandler.play_sound(sound, global_position)
				parent.distribute_signal(TakeDamageEvent.new(damage, collision.get_normal(), 1.0))

		parent.velocity = parent.velocity.slide(collision.get_normal())
		parent.distribute_signal(CollisionEvent.new(collision))


func receive_signal(event : Event) -> Event:
	event.types.attempt_move
	match event.type:
		event.types.attempt_move:
			var cast_event : AttemptMoveEvent = event as AttemptMoveEvent
			last_move_acceleration_mult = cast_event.acceleration_multiplier
			last_move_direction = cast_event.direction
			last_move_processed = false
	return event
