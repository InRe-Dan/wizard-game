class_name Projectile
extends Node2D

var data : ProjectileData
var velocity : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Light.color = data.lightColour
	$Animation.sprite_frames = data.animation
	

func setResource(res : ProjectileData) -> Projectile:
	data = res.duplicate()
	return self

func setVelocity(direction : Vector2) -> void:
	velocity = direction * data.speed
	rotation = direction.angle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	position += velocity * delta


func _on_timer_timeout() -> void:
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	velocity = Vector2(0., 0.)
	# var direction : float = (position - body.positition).angle() % TAU/4.
	# $Sprite.rotation = direction
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$Animation.play("hit")
	var soundplayer : AudioStreamPlayer = $AudioStreamPlayer
	soundplayer.play()


func _on_animation_animation_finished() -> void:
	queue_free()
