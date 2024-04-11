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
		var player : Entity = player_resource.make_entity()
		add_child(player)
		($level as Level).move_player(player)

func next_level() -> void:
	$level.generate_bsp()
