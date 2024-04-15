class_name LootComponent extends EntityComponent

var loot_table : Array[LootEntry]
var min_loot = 0
var max_loot = 0
var looted : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func throw(entity : Entity, direction : float) -> void:
	Global.level.add_child(entity)
	var dir : Vector2 = Vector2.from_angle(direction * TAU)
	entity.global_position = global_position + 12 * dir
	entity.velocity = 50 * dir

func slow_drop() -> void:
	var dropped : int = 0
	while max_loot > dropped:
		for res : LootEntry in loot_table:
			if res.rate > randf():
				throw(res.item.make_item_pickup(), randf())
				await get_tree().create_timer(0.1).timeout
				dropped += 1
			elif dropped >= min_loot:
				return

func instant_drop() -> void:
	var dropped : int = 0
	while max_loot > dropped:
		for res : LootEntry in loot_table:
			if res.rate > randf():
				throw(res.item.make_item_pickup(), randf())
				dropped += 1
			elif dropped >= min_loot:
				return

func drop_loot() -> void:
	if looted:
		return
	looted = true
	if parent.resource.type == EntityResource.EntityType.Chest:
		await get_tree().create_timer(0.5).timeout
		slow_drop()
	else:
		instant_drop()
		

func receive_signal(event : Event) -> Event:
	if event is DeathEvent or event is BeenInteractedEvent:
		drop_loot()
	return event
