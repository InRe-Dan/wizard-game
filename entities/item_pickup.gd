class_name ItemPickupEntity extends Entity

@export var item : PackedScene

var item_to_give : InventoryItem

func _ready() -> void:
	item_to_give = item.instantiate()
	$ItemSprite.texture = item_to_give.item_icon
	$PointLight2D.color = item_to_give.pickup_light_color

func distribute_signal(event : Event) -> void:
	if event.type == event.types.been_interacted:
		var interaction : BeenInteractedEvent = event as BeenInteractedEvent
		if item_to_give:
			interaction.interacter.give(item_to_give)
		queue_free()
	super(event)
