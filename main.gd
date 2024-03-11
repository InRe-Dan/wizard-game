class_name Main extends Node2D

var player_scene : PackedScene = preload("res://entities/player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	FloorHandler.init_for_room()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	if not get_tree().get_first_node_in_group("players"):
		add_child(player_scene.instantiate())
