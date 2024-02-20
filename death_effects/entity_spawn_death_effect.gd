extends DeathEffect

@export var entity : PackedScene

func trigger() -> void:
	print("Triggered!!")
	var entity : Entity = entity.instantiate() as Entity
	get_tree().get_first_node_in_group("main").add_child(entity)
	entity.global_position = get_parent().get_parent().global_position
	
