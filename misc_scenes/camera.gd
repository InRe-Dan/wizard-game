extends Camera2D
# Code adapted from https://www.reddit.com/r/godot/comments/eu5eyv/sprite_jittering/
# More potential solutions https://github.com/godotengine/godot/issues/35606
# r/godot, u/forbjok

@export var SMOOTHING_DURATION : float = 0.2
# https://gamedev.stackexchange.com/questions/1828/realistic-camera-screen-shake-from-explosion
@export var shake_radius : float = 2

@onready var health_label : Label = $UI/Health
@onready var prompt_label : Label = $UI/Prompt
@onready var item_info : Label = $UI/ItemInfo

var current_position: Vector2
var destination_position: Vector2
var is_shaking : bool = false
var shake_duration  : float = 0.0
var shake_time_elapsed : float = 0.0

func _ready() -> void:
	current_position = global_position

func _process(delta: float) -> void:
	var player : Entity = get_tree().get_first_node_in_group("players") as Entity
	if player:
		health_label.text = "HP: " + str(player.health)
		var inventory : InventoryComponent = player.get_children().filter(func f(x : Node) -> bool: return x is InventoryComponent).front()
		if inventory:
			var item : InventoryItem = inventory.get_selected()
			if item:
				item_info.text = ""
				item_info.text += item.item_name + "\n"
				if item.limited_use:
					item_info.text += str(item.uses) + "/" + str(item.max_uses) + "\n"
				else:
					item_info.text += "Unlimited use\n"
				item_info.text += item.description
			else:
				item_info.text = "Item: Nothing!"
		else:
			item_info.text = "Item: No inventory!"
		var interact_component : CanInteractComponent = player.get_children().filter(func f(x : Node) -> bool: return x is CanInteractComponent).front()
		if interact_component:
			prompt_label.visible = interact_component.interactable_found()
	else:
		health_label.text = "HP: Dead!"

func _physics_process(delta: float) -> void:
	var target: Node2D = get_tree().get_first_node_in_group("players") as Node2D
	if target:
		destination_position = target.global_position
	current_position += Vector2(destination_position.x - current_position.x, destination_position.y - current_position.y) / SMOOTHING_DURATION * delta
	global_position = current_position.round()
	if is_shaking:
		global_position += (shake_time_elapsed / shake_duration) * shake_radius * Vector2.RIGHT.rotated(randf() * TAU)
		shake_time_elapsed += delta
		if shake_time_elapsed > shake_duration:
			is_shaking = false
	force_update_scroll()

func shake(duration : float) -> void:
	is_shaking = true
	shake_duration = duration
	shake_time_elapsed = 0.0
