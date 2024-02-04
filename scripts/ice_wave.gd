class_name IceWave extends Projectile

@export var texture : Texture2D

var destroyed : bool = false
@onready var floor_effect_handler : FloorEffectHandler = get_node("/root/FloorEffectHandler") as FloorEffectHandler
@onready var ray : RayCast2D = $Ray



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

		
func _on_area_2d_body_entered(body: Node2D) -> void:
	collide()

func collide() -> void:
	velocity = 0
	$IceDropTimer.stop()
	var light_tween : Tween = get_tree().create_tween()
	light_tween.tween_property($PointLight2D, "energy", 0.0, 0.5)
	light_tween.tween_callback(queue_free)


func _on_ice_drop_timer_timeout() -> void:
	var effect : FloorEffect = floor_effect_handler.floor_effect_scene.instantiate()
	floor_effect_handler.add_effect(effect)
	effect.set_variables(FloorEffect.FloorEffectType.Ice, 5.0, global_position, 15)

