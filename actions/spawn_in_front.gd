extends Action

@export var entity : PackedScene

func _ready() -> void:
	description = "Spawn " + a_or_an((entity.instantiate() as Entity).entity_name)

func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	var entity_instance : Entity = entity.instantiate() as Entity
	entity_instance.global_position = target.global_position + direction.normalized() * 48
	get_tree().get_first_node_in_group("main").add_child(entity_instance)
	finished.emit()
