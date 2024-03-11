extends Entity

@export var item : PackedScene

func distribute_signal(event : Event) -> void:
	if event.type == event.types.been_interacted:
		var interaction : BeenInteractedEvent = event as BeenInteractedEvent
		var item : InventoryItem = item.instantiate() as InventoryItem
		if item:
			interaction.interacter.give(item)
		queue_free()
	super(event)
