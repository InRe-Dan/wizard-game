class_name RadialMenu extends Control

@onready var time_bar : TextureProgressBar = $TextureProgressBar

@export var unselected_texture : Texture2D
@export var selected_textrure : Texture2D

@export var time_slow_capacity : float = 1.0

var time_slow_juice : float = 0

# https://forum.godotengine.org/t/equivalent-of-gamemakerss-function-angle-difference/27163
func angle_difference(angle1 : float, angle2 : float) -> float:
	var diff : float = angle2 - angle1
	return diff if abs(diff) < PI else diff + (TAU * -sign(diff))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	if Input.is_action_pressed("openmenu"):
		visible = true
		time_slow_juice -= delta
		if time_slow_juice < 0:
			time_slow_juice = 0
		if time_slow_juice > 0:
			Engine.time_scale = 0.5
		else:
			Engine.time_scale = 1
	else:
		Engine.time_scale = 1
		visible = false
		time_slow_juice += delta
		if time_slow_juice > time_slow_capacity:
			time_slow_juice = time_slow_capacity
		return
	var player : Entity = get_tree().get_first_node_in_group("players")
	if not player:
		return
	for child : Node in get_children():
		if child is TextureProgressBar:
			continue
		remove_child(child)
		child.queue_free()
	
	var inventory : InventoryComponent = null
	for node : Node in player.get_children():
		if node is InventoryComponent:
			inventory = node as InventoryComponent
			break
	assert(inventory)

	time_bar.global_position = get_viewport_rect().get_center() - Vector2.ONE * time_bar.texture_progress.get_size().x / 2
	time_bar.value = time_slow_juice / time_slow_capacity

	var items : Array[InventoryItem] = inventory.get_items()
	var selected : int = 0
	for i : int in range(items.size()):
		var item : InventoryItem = items[i]
		var rect : TextureRect = TextureRect.new()
		var background_rect : TextureRect = TextureRect.new()
		var angle : float = TAU * float(i) / items.size()
		if item:
			rect.texture = item.resource.inventory_icon
		else:
			rect.texture = null
		add_child(background_rect)
		add_child(rect)
		rect.size *= 2
		rect.global_position = get_viewport_rect().get_center() - Vector2.ONE * 8 + Vector2.from_angle(angle) * 50
		background_rect.global_position = get_viewport_rect().get_center() - Vector2.ONE * 15 + Vector2.from_angle(angle) * 50
		
		var centre : Vector2 = get_viewport_rect().get_center()
		var to_mouse : float = (centre - get_global_mouse_position()).angle()
		var to_item : float = (centre - rect.global_position).angle()
		var diff : float = angle_difference(to_mouse + PI, to_item + PI) * 2
		if - TAU / items.size() < diff and diff < TAU / items.size():
			background_rect.texture = selected_textrure
			selected = i
		else:
			background_rect.texture = unselected_texture
	inventory.selected = selected
