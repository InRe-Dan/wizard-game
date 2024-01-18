extends Node2D

var velocity : Vector2;
var speed : float = 200;

func setVelocity(direction : Vector2) -> void:
	velocity = direction * speed
	$Sprite.play("fly")
	rotation = direction.angle()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	position += velocity * delta


func _on_timer_timeout() -> void:
	queue_free()



func _on_sprite_animation_finished() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	velocity = Vector2(0., 0.)
	# var direction : float = (position - body.positition).angle() % TAU/4.
	# $Sprite.rotation = direction
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	var soundplayer : AudioStreamPlayer = $AudioStreamPlayer
	soundplayer.play()
	$Sprite.play("hit") # Replace with function body.
