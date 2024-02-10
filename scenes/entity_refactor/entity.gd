class_name Entity extends CharacterBody2D

@export var acceleration : float = 500
@export var damping : float = 5


var move : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	velocity += move * acceleration * delta
	velocity = velocity / (1 + damping * delta)
	move -= move
	move_and_slide()

func distribute_signal(emitter : Entity, event : Event) -> void:
	match event.type:
		Event.types.inputmove:
			move = (event as InputMoveEvent).direction
		_:
			pass
	
	for child : Node2D in get_children():
		if child as EntityComponent:
			event = (child as EntityComponent).receive_signal(emitter, event)
