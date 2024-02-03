class_name FloorEffect extends Node2D

enum FloorEffectType {Fire, Water, Ice}

var type : FloorEffectType
var duration : float
var lifetime : float
var radius : float
var color_rect : ColorRect

func _init(t : FloorEffectType, d : float, pos : Vector2, r : float) -> void:
	type = t
	duration = d
	lifetime = d
	global_position = pos
	radius = r
	color_rect = ColorRect.new()
	add_child(color_rect)
	color_rect.color = Color(1, 1, 1, 0.6)
	color_rect.size = Vector2(r * 2, r * 2)
	color_rect.position -= Vector2(r, r)
	color_rect.z_index = 300
	color_rect.material = ShaderMaterial.new()
	color_rect.material.shader = preload("res://shaders/ice.gdshader") as Shader
	color_rect.z_as_relative = false
	color_rect.z_index = 1
	color_rect.material.set_shader_parameter("noise", preload("res://assets/noise_patterns/ice_noise_texture.tres") as Texture2D)
	color_rect.material.set_shader_parameter("global_transform", get_global_transform())
	color_rect.material.set_shader_parameter("lifetime_percentage", 1.0)

func tick_down(delta : float) -> bool:
	duration -= delta
	color_rect.material.set_shader_parameter("lifetime_percentage", duration / lifetime)
	if duration < 0.0:
		return true
	return false

