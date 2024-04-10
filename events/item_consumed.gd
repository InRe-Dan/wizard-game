class_name ItemConsumedEvent extends Event

var item : InventoryItem

func _init(item : InventoryItem) -> void:
	self.item = item
	self.type = types.item_consumed
