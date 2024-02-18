class_name Entity extends CharacterBody2D

@export var acceleration : float = 500
@export var spawn_velocity : float = 500
@export var damping : float = 5
@export var health : int = 5

enum Team {player, enemy, any}

var move : Vector2
var creator : Entity = null
var team : Team = Team.any

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func _physics_process(delta: float) -> void:
	velocity += move * acceleration * delta
	velocity = velocity / (1 + damping * delta)
	move = Vector2()
	# velocity = velocity.limit_length(1000)
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.slide(collision.get_normal())
		distribute_signal(CollisionEvent.new(collision))

func distribute_signal(event : Event) -> void:

	match event.type:
		Event.types.inputmove:
			move = (event as InputMoveEvent).direction
		_:
			pass
	
	for child : Node2D in get_children():
		if child as EntityComponent:
			event = (child as EntityComponent).receive_signal(event)

	match event.type:
		Event.types.has_hit:
			var hit : HasHitEvent = event as HasHitEvent 
			hit.target.distribute_signal(BeenHitEvent.new(self, hit.damage))
			print_orphan_nodes()
		Event.types.been_hit:
			var hit : BeenHitEvent = event as BeenHitEvent
			distribute_signal(TakeDamageEvent.new(hit.dealer, hit.damage))
			hit.dealer.distribute_signal(DealtDamageEvent.new(self, hit.damage))
		Event.types.take_damage:
			var hit : TakeDamageEvent = event as TakeDamageEvent
			health -= hit.damage.damage
			print(self, " ", health)
			if health <= 0:
				queue_free()
		_:
			pass
	# stops memory leak
	event.queue_free()
