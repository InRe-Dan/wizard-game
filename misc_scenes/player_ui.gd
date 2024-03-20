extends Control

@onready var item_info : Label = $VBoxContainer/ItemInfo
@onready var health_label : Label = $VBoxContainer/HBoxContainer/Health
@onready var prompt_label : Label = $VBoxContainer/Prompt
@onready var cooldown : TextureProgressBar = $VBoxContainer/HBoxContainer/VBoxContainer/ItemCooldown
@onready var effect_icons : HBoxContainer = $VBoxContainer/EffectIcons

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
			effect.updated.connect(update_icon)
			var rect : TextureRect = TextureRect.new()
			rect.expand_mode = rect.EXPAND_KEEP_SIZE
			rect.texture = effect.icon
			rect.tooltip_text = effect.effect_name + "\n" + effect.effect_description
			effect_icons.add_child(rect)
			effect_to_rect[effect] = rect
	for effect : Effect in effect_to_rect.keys():
		if not effects.has(effect):
			effect_icons.remove_child(effect_to_rect[effect])
			effect_to_rect.erase(effect)

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
		var interact_component : CanInteractComponent = player.get_children().filter(func f(x : Node) -> bool: return x is CanInteractComponent).front()
		if interact_component:
			prompt_label.visible = interact_component.interactable_found()
		var effect_component : EffectContainerComponent = player.get_children().filter(func f(x : Node) -> bool: return x is EffectContainerComponent).front()
		populate_icons(effect_component.get_children())
	else:
		health_label.text = "HP: Dead!"
