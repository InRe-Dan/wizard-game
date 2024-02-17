extends ItemAction

@export var projectile : PackedScene

func do(caller : Entity, direction : Vector2) -> void:
	var entity_instance : Entity = projectile.instantiate() as Entity
	entity_instance.velocity = entity_instance.spawn_velocity * direction
	entity_instance.global_position = caller.global_position
	entity_instance.team = caller.team
	entity_instance.creator = caller
	get_tree().get_first_node_in_group("main").add_child(entity_instance)
