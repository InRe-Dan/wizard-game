class_name EntityResource extends Resource

enum EntityType {Player, Enemy, Melee, Projectile, ItemPickup, PassivePickup, StaticProjectile}
enum EntityTeam {Player, Enemy, Any}
enum EntityElement {None, Fire, Ice, Water}

@export var entity_name : String
@export var _entity_scene : PackedScene
@export var starting_health : int
@export var spawn_velocity : int 
@export var type : EntityType
@export var default_team : EntityTeam
@export var element : EntityElement

func make_entity() -> Entity:
	var entity : Entity = _entity_scene.instantiate()
	if entity:
		entity.resource = self
		entity.health = starting_health
		entity.team = default_team
		return entity
	push_error("Failed to create an entity.")
	return null
