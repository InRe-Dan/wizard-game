extends EntityComponent

@export var base_acceleration : float = 500
@export var base_damping : float = 5
@export var knockback_damage_min_speed : float = 150

var last_move_processed : bool = true
var last_move_direction : Vector2
var last_move_acceleration_mult : float

func _physics_process(delta : float) -> void:
	if not last_move_processed:
		last_move_processed = true
		parent.velocity += last_move_direction * base_acceleration * last_move_acceleration_mult * delta
	parent.velocity = parent.velocity / (1 + base_damping * delta)
	var collision : KinematicCollision2D = parent.move_and_collide(parent.velocity * delta)
	
	if collision:
		if parent.knockback_time - Time.get_ticks_msec() < parent.knockback_valid_timer * 1000:
			if knockback_damage_min_speed < parent.velocity.length():
				var damage : DamageData = DamageData.new()
				damage.damage = floor(parent.velocity.length() / knockback_damage_min_speed)
				damage.damage_type = damage.DamageTypes.kinetic
				damage.knockback_velocity = parent.velocity.length() * 0.5
				parent.say("THUD!")
				parent.distribute_signal(TakeDamageEvent.new(damage, collision.get_normal()))

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

