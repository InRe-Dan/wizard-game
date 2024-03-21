class_name Main extends Node2D

var player_resource : EntityResource = preload("res://resources/entities/player.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player : Entity = player_resource.make_entity()
	add_child(player)
	$level.move_player(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	if not get_tree().get_first_node_in_group("players"):
		add_child(player_resource.make_entity())
