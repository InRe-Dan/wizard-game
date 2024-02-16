class_name Entity extends CharacterBody2D

@export var acceleration : float = 500
@export var damping : float = 5


var move : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
func _physics_process(delta: float) -> void:
	velocity += move * acceleration * delta
	velocity = velocity / (1 + damping * delta)
	move -= move
	velocity = velocity.limit_length(1000)
	var collision : KinematicCollision2D = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.slide(collision.get_normal())
		distribute_signal(self, CollisionEvent.new(collision))

func distribute_signal(emitter : Entity, event : Event) -> void:
	match event.type:
		Event.types.inputmove:
			move = (event as InputMoveEvent).direction
		_:
			pass
	
	for child : Node2D in get_children():
		if child as EntityComponent:
			event = (child as EntityComponent).receive_signal(emitter, event)
