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

func throw(entity : Entity, direction : int) -> void:
	Global.level.add_child(entity)
	var dir : Vector2 = Vector2.from_angle((floor(randf() * direction) / direction) * TAU)
	entity.global_position = global_position + 12 * dir
	entity.velocity = 50 * dir

func drop_loot() -> void:
	if not looted:
		var divisions : Array = range(items.size() * 2 + passives.size() * 2)
		divisions.shuffle()
		for item : ItemResource in items:
			var entity : Entity = item.make_item_pickup()
			throw(entity, divisions.pop_front())
		for passive : PassiveResource in passives:
			var entity : Entity = passive.make_item_pickup()
			throw(entity, divisions.pop_front())
	looted = true

func receive_signal(event : Event) -> Event:
	if event is DeathEvent:
		drop_loot()
	if event is BeenInteractedEvent:
		drop_loot()
	return event
