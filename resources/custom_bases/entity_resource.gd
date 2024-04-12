class_name EntityResource extends Resource

enum EntityType {Player, Enemy, Melee, Projectile, ItemPickup, PassivePickup, StaticProjectile}
enum EntityTeam {Player, Enemy, Any}
enum EntityElement {None, Fire, Ice, Water}

@export var entity_name : String
@export var _entity_scene : PackedScene
@export var starting_health : int
@export var spawn_velocity : int 
@export var type : EntityType
@export var inherit_team : bool = true
@export var default_team : EntityTeam
@export var element : EntityElement
@export var loot_table : Dictionary

var loot_component = load("res://components/loot_component.tscn")

func make_entity(max_loot : int = 0) -> Entity:
	var entity : Entity = _entity_scene.instantiate()
	if entity:
		entity.resource = self
		entity.health = starting_health
		entity.team = default_team
		if max_loot > 0:
			var loot_to_give = max_loot
			if loot_to_give == 0:
				return entity
			var component : LootComponent = loot_component.instantiate()
			var keys : Array[Variant] = loot_table.keys()
			keys.shuffle()
			for i : int in range(keys.size()):
				if loot_table[keys[i]] < randf():
					continue
				loot_to_give -= 1
				var item : ItemResource = keys[i] as ItemResource
				var passive : PassiveResource = keys[i] as PassiveResource
				if item:
					component.items.append(item)
				elif passive:
					component.passives.append(passive)
			entity.add_child(component)
		return entity
	push_error("Failed to create an entity.")
	return null
