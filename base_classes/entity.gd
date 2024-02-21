class_name Entity extends CharacterBody2D

@export var acceleration : float = 500
@export var spawn_velocity : float = 500
@export var damping : float = 5
@export var health : int = 5

enum Team {player, enemy, any}

var knocked_back_by : Entity = null
var knockback_time : float
const knockback_valid_timer : float = 0.1
const knockback_damage_min_speed : float = 300

var move : Vector2
var creator : Entity = null
var team : Team = Team.any

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_as_relative = false
	z_index = 2
	say("Spawned in!")
	
func _physics_process(delta: float) -> void:
	velocity += move * acceleration * delta
	velocity = velocity / (1 + damping * delta)
	move = Vector2()
	# velocity = velocity.limit_length(1000)
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	
	if collision:
		velocity = velocity.slide(collision.get_normal())
		if knockback_valid_timer + knockback_time * 1000 < Time.get_ticks_msec():
			if knockback_damage_min_speed > velocity.length():
				say("THUD!")
				var damage : DamageData = DamageData.new()
				damage.damage = ceil(velocity.length() / knockback_damage_min_speed)
				damage.damage_type = damage.DamageTypes.kinetic
				distribute_signal(TakeDamageEvent.new(knocked_back_by, damage))
		velocity = velocity.slide(collision.get_normal())
		distribute_signal(CollisionEvent.new(collision))

func distribute_signal(event : Event) -> void:

	match event.type:
		Event.types.inputmove:
			move = (event as InputMoveEvent).direction
		_:
			pass
	
	for child : Node in get_children():
		if child as EntityComponent:
			event = (child as EntityComponent).receive_signal(event)

	match event.type:
		Event.types.has_hit:
			say("Take that!")
			var hit : HasHitEvent = event as HasHitEvent 
			hit.target.distribute_signal(BeenHitEvent.new(self, hit.damage))
			print_orphan_nodes()
		Event.types.been_hit:
			var hit : BeenHitEvent = event as BeenHitEvent
			distribute_signal(TakeDamageEvent.new(hit.dealer, hit.damage))
			hit.dealer.distribute_signal(DealtDamageEvent.new(self, hit.damage))
		Event.types.take_damage:
			say("Ouch!")
			var hit : TakeDamageEvent = event as TakeDamageEvent
			knocked_back_by = hit.dealer
			knockback_time = Time.get_ticks_msec()
			health -= hit.damage.damage
			print(self, " ", health)
			if hit.damage.knockback_velocity > 0.0:
				match hit.damage.knockback_type:
					DamageData.KnockbackTypes.origin:
						velocity += (global_position - hit.dealer.global_position).normalized() * hit.damage.knockback_velocity
					DamageData.KnockbackTypes.velocity:
						velocity += hit.dealer.velocity.normalized() * hit.damage.knockback_velocity
			if health <= 0:
				distribute_signal(DeathEvent.new(hit.dealer))
				queue_free()
		_:
			pass
	# HACK stops memory leak?
	event.queue_free()
	
func say(text : String) -> void:
	distribute_signal(SpeechEvent.new(text))

