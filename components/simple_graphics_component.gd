class_name SimpleGraphics extends EntityComponent
# Supports 3 different animations: idle, move and attack

@export var has_footstep_particles : bool = false

@onready var sprite : AnimatedSprite2D = get_children().filter(func x(x : Variant) -> bool: return x is AnimatedSprite2D).front()
@onready var footstep : GPUParticles2D

var flash_tween : Tween
var moved : bool = false

func emit_footsteps() -> void:
	if sprite.animation == "move" and has_footstep_particles:
		footstep.emitting = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if has_footstep_particles:
		footstep = get_children().filter(func x(x : Variant) -> bool: return x is GPUParticles2D).front()
	sprite.play("idle")
	sprite.connect("animation_looped", emit_footsteps)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not parent is Player:
		sprite.flip_h = not (parent.global_position.direction_to(parent.looking_at).angle_to(Vector2.UP) < 0)
	if not moved:
		sprite.play("idle")
	moved = false

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
			if not sprite.animation == "move":
				sprite.play("move")
			moved = true
			if (event as InputMoveEvent).direction.x < 0.0 and parent is Player:
				sprite.flip_h = true
			elif (event as InputMoveEvent).direction.x > 0.0 and parent is Player:
				sprite.flip_h = false
		Event.types.take_damage:
			flash()
	return event
