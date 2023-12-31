extends Node2D

var open : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !open:
		open = true
		$AnimatedSprite2D.play("default")
		$FlashTimer.start()
		$DeleteTimer.start()


func _on_timer_timeout() -> void:
	queue_free()


func _on_flash_timer_timeout() -> void:
	$AnimatedSprite2D.material.set_shader_parameter("active", true);
