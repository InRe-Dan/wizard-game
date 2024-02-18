class_name SimpleGraphics extends EntityComponent
# Supports 3 different animations: idle, move and attack

@onready var sprite : AnimatedSprite2D = get_children().front() as AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not sprite.is_playing():
		sprite.play("idle")

func receive_signal(event : Event) -> Event:
	match event.type:
		Event.types.inputmove:
			sprite.play("move")
			if (event as InputMoveEvent).direction.x < 0.0:
				sprite.flip_h = true
			elif (event as InputMoveEvent).direction.x > 0.0:
				sprite.flip_h = false
	return event
