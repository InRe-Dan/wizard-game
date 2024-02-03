class_name IceBolt extends Projectile

@export var texture : Texture2D

var destroyed : bool = false
@onready var floor_effect_handler : FloorEffectHandler = get_node("/root/FloorEffectHandler") as FloorEffectHandler
@onready var collision_timer : Timer = $CollisionDespawnTimer
@onready var ray : RayCast2D = $Ray



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

		
func _on_area_2d_body_entered(body: Node2D) -> void:
	collide()

func collide() -> void:
	velocity = 0
	destroyed = true
	collision_timer.start()


func _on_ice_drop_timer_timeout() -> void:
	floor_effect_handler.add_effect(FloorEffect.new(FloorEffect.FloorEffectType.Ice, 5.0, global_position, 15))

