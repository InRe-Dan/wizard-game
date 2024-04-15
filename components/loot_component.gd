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

func drop_loot() -> void:
	if not looted:
		var dropped : int = 0
		while dropped < min_loot and max_loot > dropped:
			for res : LootEntry in loot_table:
				if res.rate > randf():
					throw(res.item.make_item_pickup(), randf())
					dropped += 1
					if dropped >= max_loot:
						break
	looted = true

func receive_signal(event : Event) -> Event:
	if event is DeathEvent:
		drop_loot()
	if event is BeenInteractedEvent:
		drop_loot()
	return event
