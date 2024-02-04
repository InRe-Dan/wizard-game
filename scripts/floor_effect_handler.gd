extends Node

@onready var floor_effects_container : Node2D = get_tree().get_first_node_in_group("main").get_node("FloorEffects") as Node2D

const floor_effect_scene : PackedScene = preload("res://scenes/floor_effect.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for effect : Node2D in floor_effects_container.get_children():
		if (effect as FloorEffect).tick_down(delta):
			floor_effects_container.remove_child(effect)

func add_effect(effect : FloorEffect) -> void:
	floor_effects_container.add_child(effect)
