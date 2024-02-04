class_name FloorEffect extends Node2D

enum FloorEffectType {Fire, Water, Ice}

var type : FloorEffectType
var duration : float
var lifetime : float
var radius : float

@onready var sprite : Sprite2D = $Sprite2D
@onready var collision_shape : CollisionShape2D = $Area2D/CollisionShape2D

func set_variables(t : FloorEffectType, d : float, pos : Vector2, r : float) -> void:
	type = t
	duration = d
	lifetime = d
	global_position = pos
	radius = r
	
	(collision_shape.shape as CircleShape2D).radius = r
	
	sprite.material = sprite.material.duplicate()
	sprite.scale = Vector2(r * 2, r * 2)
	sprite.position += Vector2(r, r)
	
	sprite.material.set_shader_parameter("noise", preload("res://assets/noise_patterns/ice_noise_texture.tres") as Texture2D)
	sprite.material.set_shader_parameter("global_transform", get_global_transform())
	sprite.material.set_shader_parameter("lifetime_percentage", 1.0)

func tick_down(delta : float) -> bool:
	duration -= delta
	sprite.material.set_shader_parameter("lifetime_percentage", duration / lifetime)
	if duration < 0.0:
		return true
	return false
	
func apply_fire() -> void:
	if type == FloorEffectType.Ice:
		queue_free()

func apply_water() -> void:
	if type == FloorEffectType.Fire:
		queue_free()

func apply_ice() -> void:
	if type == FloorEffectType.Water:
		queue_free()
