extends Action

@export var projectile : EntityResource
@export var side_projectiles : int = 0
@export var spread : float = 30
@export var cast_distance : float = 12

func _ready() -> void:
	if side_projectiles == 0:
		description = "Shoot " + a_or_an(projectile.entity_name)
	else:
		description = "Shoot a spread of " + projectile.entity_name + "s"

func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	var team : EntityResource.EntityTeam = target.team
	if not projectile.inherit_team:
		team = projectile.default_team
	var entity_instance : Entity = projectile.make_entity() as Entity
	entity_instance.velocity = projectile.spawn_velocity * direction
	entity_instance.global_position = target.global_position + direction * cast_distance
	entity_instance.team = team
	get_tree().get_first_node_in_group("main").add_child(entity_instance)
	target.distribute_signal(CreatedProjectileEvent.new(entity_instance))
	for i : int in range(side_projectiles):
		entity_instance = projectile.make_entity() as Entity
		entity_instance.velocity = projectile.spawn_velocity * direction.rotated(-deg_to_rad(spread * (i + 1) / side_projectiles))
		entity_instance.global_position = target.global_position + direction.rotated(-deg_to_rad(spread * (i + 1) / side_projectiles)) * cast_distance
		entity_instance.team = team
		get_tree().get_first_node_in_group("main").add_child(entity_instance)
		target.distribute_signal(CreatedProjectileEvent.new(entity_instance))
		
		entity_instance = projectile.make_entity() as Entity
		entity_instance.velocity = projectile.spawn_velocity * direction.rotated(deg_to_rad(spread * (i + 1) / side_projectiles))
		entity_instance.global_position = target.global_position + direction.rotated(deg_to_rad(spread * (i + 1) / side_projectiles)) * cast_distance
		entity_instance.team = team
		get_tree().get_first_node_in_group("main").add_child(entity_instance)
		target.distribute_signal(CreatedProjectileEvent.new(entity_instance))
	finished.emit()
