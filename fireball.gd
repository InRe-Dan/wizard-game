extends Node2D

var velocity : Vector2;
var speed : float = 200;

func setVelocity(direction : Vector2):
	velocity = direction * speed
	$Sprite.play("fly")
	rotation = direction.angle()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += velocity * delta


func _on_timer_timeout():
	queue_free()



func _on_sprite_animation_finished() -> void:
	queue_free()# Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(Node2D)
	velocity = Vector2(0., 0.)
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	$Sprite.play("hit") # Replace with function body.


func _on_area_2d_area_entered(area: Area2D) -> void:
	print(Node2D)
	velocity = Vector2(0., 0.)
	$Sprite.play("hit") # Replace with function body.
