extends Control

@onready var item_info : Label = $VBoxContainer/ItemInfo
@onready var health_label : Label = $VBoxContainer/HBoxContainer/Health
@onready var cooldown : TextureProgressBar = $VBoxContainer/HBoxContainer/VBoxContainer/ItemCooldown
@onready var effect_icons : GridContainer = $VBoxContainer/EffectIcons

var effect_to_rect : Dictionary = {}

func update_icon(effect : Effect) -> void:
	if effect in effect_to_rect.keys():
		var rect : TextureRect = effect_to_rect[effect]
		rect.texture = effect.icon
		rect.tooltip_text = effect.effect_name + "\n" + effect.effect_description
		
func populate_icons(effects : Array) -> void:
	effects = effects.filter(func x(a : Effect) -> bool: return a.is_visible)
	for effect : Effect in effects:
		if not effect_to_rect.has(effect):
			if not effect.updated.is_connected(update_icon):
				effect.updated.connect(update_icon)
			var rect : TextureRect = TextureRect.new()
			rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			rect.expand_mode = rect.EXPAND_KEEP_SIZE
			rect.texture = effect.icon
			rect.tooltip_text = effect.effect_name + "\n" + effect.effect_description
			effect_icons.add_child(rect)
			effect_to_rect[effect] = rect
	var keys : Array = effect_to_rect.keys()
	for i : int in range(keys.size()):
		if is_instance_valid(keys[i]):
			var effect : Effect = keys[i]
			if not effects.has(effect):
				effect_icons.remove_child(effect_to_rect[effect])
				effect_to_rect[effect].queue_free()
				effect_to_rect.erase(effect)
		else:
			effect_to_rect[keys[i]].queue_free()
			effect_to_rect.erase(keys[i])

func _process(delta: float) -> void:
	var player : Entity = get_tree().get_first_node_in_group("players") as Entity
	if player:
		health_label.text = "HP: " + str(player.health)
		var inventory : InventoryComponent = player.get_children().filter(func f(x : Node) -> bool: return x is InventoryComponent).front()
		if inventory:
			var item : InventoryItem = inventory.get_selected()
			if item:
				item_info.text = ""
				item_info.text += item.resource.item_name + "\n"
				if item.resource.limited_use:
					item_info.text += str(item.uses) + "/" + str(item.resource.item_durability) + "\n"
				else:
					item_info.text += "Unlimited use\n"
				item_info.text += item.description
			else:
				item_info.text = "Item: Nothing!"
			cooldown.value = inventory.get_item_cooldown_progress()
		else:
			item_info.text = "Item: No inventory!"
		var effect_component : EffectContainerComponent = player.get_children().filter(func f(x : Node) -> bool: return x is EffectContainerComponent).front()
		populate_icons(effect_component.get_children())
	else:
		health_label.text = "HP: Dead!"
