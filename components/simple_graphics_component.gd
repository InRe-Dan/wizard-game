class_name SimpleGraphics extends EntityComponent
# Supports 3 different animations: idle, move and attack

@onready var sprite : AnimatedSprite2D = get_children().front() as AnimatedSprite2D

var flash_tween : Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play("idle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not sprite.is_playing():
		sprite.play("idle")

func flash() -> void:
	if flash_tween:
		flash_tween.stop()
	flash_tween = get_tree().create_tween()
	sprite.modulate.g = 0.0
	sprite.modulate.b = 0.0
	flash_tween.set_parallel()
	flash_tween.tween_property(sprite, "modulate:g", 1.0, 0.15)
	flash_tween.tween_property(sprite, "modulate:b", 1.0, 0.15)

func receive_signal(event : Event) -> Event:
	match event.type:
		Event.types.inputmove:
			sprite.play("move")
			if (event as InputMoveEvent).direction.x < 0.0:
				sprite.flip_h = true
			elif (event as InputMoveEvent).direction.x > 0.0:
				sprite.flip_h = false
		Event.types.take_damage:
			flash()
	return event
