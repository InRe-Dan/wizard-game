class_name Main extends Node2D

@onready var player : Player = $Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	pass

func getPlayer() -> Player:
	return player
