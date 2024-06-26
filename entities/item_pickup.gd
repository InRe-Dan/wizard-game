class_name ItemPickupEntity extends Entity

@export var item : ItemResource

var item_to_give : InventoryItem

func _ready() -> void:
	if not item_to_give:
		item_to_give = item.make_item()
	$ItemSprite.texture = item_to_give.resource.inventory_icon
	$PointLight2D.color = item_to_give.resource.glow

func distribute_signal(event : Event) -> void:
	if event.type == event.types.been_interacted:
		var interaction : BeenInteractedEvent = event as BeenInteractedEvent
		if item_to_give:
			interaction.interacter.give(item_to_give)
			if interaction.interacter is Player:
				Global.announce_item(item_to_give.resource)
		queue_free()
	super(event)
