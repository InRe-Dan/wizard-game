extends Action

@export var entity : PackedScene
@export var distance : float = 0

func _ready() -> void:
	description = "Spawn an entity. You shouldn't be holding this"

func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	var entity : Entity = entity.instantiate() as Entity
	entity.global_position = target.global_position
	target.distribute_signal(CreatedProjectileEvent.new(entity))
	get_tree().get_first_node_in_group("main").add_child(entity)
	finished.emit()
