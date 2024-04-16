class_name EntityResource extends Resource

enum EntityType {Player, Enemy, Melee, Projectile, ItemPickup, PassivePickup, StaticProjectile, Chest}
enum EntityTeam {Player, Enemy, Any}
enum EntityElement {None, Fire, Ice, Water}

@export var entity_name : String
@export var _entity_scene : PackedScene
@export var starting_health : int
@export var spawn_velocity : int 
@export var type : EntityType
@export var inherit_team : bool = true
@export var default_team : EntityTeam
@export var death_score_value : int = 0
@export var element : EntityElement
@export var min_loot : int = 0
@export var max_loot : int = 0
@export var loot_table : Array[LootEntry]

var loot_component = load("res://components/loot_component.tscn")

func make_entity() -> Entity:
	var entity : Entity = _entity_scene.instantiate()
	if entity:
		entity.resource = self
		entity.health = starting_health
		entity.team = default_team
		if max_loot > 0 and not loot_table.is_empty():
			var component : LootComponent = loot_component.instantiate()
			var copy : Array[LootEntry] = loot_table.duplicate()
			copy.shuffle()
			component.loot_table = copy
			component.min_loot = min_loot
			component.max_loot = max_loot
			entity.add_child(component)
		return entity
	push_error("Failed to create an entity.")
	return null
