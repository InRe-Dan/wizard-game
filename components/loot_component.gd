class_name LootComponent extends EntityComponent

var items : Array[ItemResource]
var passives : Array[PassiveResource]
var looted : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func throw(entity : Entity, direction : float) -> void:
	print("Threw ", entity.resource.entity_name)
	Global.level.add_child(entity)
	print(direction)
	var dir : Vector2 = Vector2.from_angle(direction * TAU)
	entity.global_position = global_position + 12 * dir
	print(entity.global_position)
	entity.velocity = 50 * dir
	print()

func drop_loot() -> void:
	if not looted:
		for item : ItemResource in items:
			var entity : Entity = item.make_item_pickup()
			throw(entity, randf())
		for passive : PassiveResource in passives:
			var entity : Entity = passive.make_item_pickup()
			throw(entity, randf())
	looted = true

func receive_signal(event : Event) -> Event:
	if event is DeathEvent:
		drop_loot()
	if event is BeenInteractedEvent:
		drop_loot()
	return event
