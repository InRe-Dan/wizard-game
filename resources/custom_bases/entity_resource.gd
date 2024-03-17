class_name EntityResource extends Resource

enum EntityType {Player, Enemy, Projectile, Melee, StaticProjectile, ItemPickup, EffectPickup}
enum EntityAffinity {None, Fire, Ice, Water}
enum Team {Player, Enemy, Any}

@export var entity_name : String = "Unnamed Entity"
@export var spawn_velocity : float = 500
@export var start_health : int = 5
@export_enum("Player", "Enemy", "Any") var team : int = Team.Any
@export_enum("Player", "Enemy", "Projectile", "Melee", "Static Projectile", "ItemPickup", "EffectPickup") \
	var entity_type : int = -1
@export_enum("None", "Fire", "Ice", "Water") var affinity : int = EntityAffinity.None
@export var _entity_scene : PackedScene

func make_entity() -> Entity:
	if entity_type == -1:
		push_error("Entity type not assigned.")
	if _entity_scene:
		var entity : Entity = _entity_scene.instantiate() as Entity
		if entity:
			entity.health = start_health
			entity.resource = self
	push_error("Failed to create entity.")
	return null
