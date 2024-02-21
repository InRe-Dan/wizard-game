extends Action

@export var projectile : PackedScene

func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	var entity_instance : Entity = projectile.instantiate() as Entity
	entity_instance.velocity = entity_instance.spawn_velocity * direction
	entity_instance.global_position = target.global_position
	entity_instance.team = target.team
	entity_instance.creator = target
	get_tree().get_first_node_in_group("main").add_child(entity_instance)
