extends Action

@export var entity : PackedScene

func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	var entity : Entity = entity.instantiate() as Entity
	get_tree().get_first_node_in_group("main").add_child(entity)
	entity.global_position = target.global_position