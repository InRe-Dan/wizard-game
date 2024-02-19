extends ItemAction

@export var entity : PackedScene

func do(caller : Entity, direction : Vector2) -> void:
	var entity_instance : Entity = entity.instantiate() as Entity
	entity_instance.global_position = caller.global_position + direction.normalized() * 48
	get_tree().get_first_node_in_group("main").add_child(entity_instance)
