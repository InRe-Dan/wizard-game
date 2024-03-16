class_name ItemResource extends Resource

enum Elements {FIRE, ICE, WATER, KINETIC}
enum ItemTypes {RANGED, MELEE, BUFF, SUMMON}

@export var item_name : String  = "Unnamed item"
@export_enum("Fire", "Ice", "Water", "Kinetic") var element : int = Elements.KINETIC
@export_enum("Ranged", "Melee", "Buff", "Summon") var type : int = ItemTypes.RANGED
@export var limited_use : bool = true
@export var item_durability : int = 10
@export var inventory_icon : Texture2D = PlaceholderTexture2D.new()
@export var glow : Color = Color.WHITE
@export var _item_scene : PackedScene = null

var item_pickup_scene : PackedScene = preload("res://entities/item_pickup.tscn")

func make_item() -> InventoryItem:
	if _item_scene:
		var item : InventoryItem = _item_scene.instantiate() as InventoryItem
		if item:
			item.resource = self
			return item
	push_error("Failed to create an item.")
	return null

func make_item_pickup() -> Entity:
	return null
