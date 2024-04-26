class_name Main extends Node2D

var player_resource : EntityResource = preload("res://resources/entities/player.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player : Entity = player_resource.make_entity()
	add_child(player)
	$level.generate_bsp()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	if not get_tree().get_first_node_in_group("players"):
		return
		var player : Entity = player_resource.make_entity()
		add_child(player)
		($level as Level).move_player(player)

func regen_after_delay() -> void:
	await get_tree().create_timer(5).timeout
	await transition()
	Global.floor_number = 1
	var player : Entity = player_resource.make_entity()
	add_child(player)
	$level.generate_bsp()
	await get_tree().create_timer(1).timeout
	detransition()

func transition() -> void:
	var rect : ColorRect = get_tree().get_first_node_in_group("postprocessrect")
	var shader : ShaderMaterial = rect.material as ShaderMaterial
	var tween = get_tree().create_tween()
	var lambda = func a(x : float): shader.set_shader_parameter("quantizationSteps", x)
	tween.tween_method(lambda, shader.get_shader_parameter("quantizationSteps"), 0, 3)
	tween.tween_interval(1)
	await tween.finished

func detransition() -> void:
	var rect : ColorRect = get_tree().get_first_node_in_group("postprocessrect")
	var shader : ShaderMaterial = rect.material as ShaderMaterial
	var tween = get_tree().create_tween()
	var lambda = func a(x : float): shader.set_shader_parameter("quantizationSteps", x)
	tween.tween_method(lambda, shader.get_shader_parameter("quantizationSteps"), 16, 1)
	await tween.finished

func next_level() -> void:
	Global.floor_number += 1
	if Global.floor_number > 3:
		Global.queue_announcement("YOU WIN!", "Keep going for a high score!", Color.DARK_GREEN, [0.1, 15, 0.5])
	await get_tree().create_timer(5).timeout
	await transition()
	$level.generate_bsp()
	detransition()
