class_name SpawnAngelAction extends ItemAction

var angel_scene : PackedScene = preload("res://scenes/entity_refactor/demon_entity.tscn")

func do(caller : Entity, direction : Vector2) -> void:
	get_tree().get_first_node_in_group("main").add_child(angel_scene.instantiate())
