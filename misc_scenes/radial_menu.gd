class_name RadialMenu extends Control

@export var unselected_texture : Texture2D
@export var selected_textrure : Texture2D

# https://forum.godotengine.org/t/equivalent-of-gamemakerss-function-angle-difference/27163
func angle_difference(angle1 : float, angle2 : float) -> float:
	var diff : float = angle2 - angle1
	return diff if abs(diff) < PI else diff + (TAU * -sign(diff))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	if Input.is_action_pressed("openmenu"):
		visible = true
	else:
		visible = false
		return
	var player : Entity = get_tree().get_first_node_in_group("players")
	if not player:
		return
	for child : Node in get_children():
		remove_child(child)
	
	var inventory : InventoryComponent = null
	for node : Node in player.get_children():
		if node is InventoryComponent:
			inventory = node as InventoryComponent
			break
	
	var items : Array[Node] = inventory.get_items()
	var selected : int = 0
	for i : int in range(items.size()):
		var rect : TextureRect = TextureRect.new()
		var background_rect : TextureRect = TextureRect.new()
		var angle : float = TAU * float(i) / items.size()
		rect.texture = (items[i] as InventoryItem).resource.inventory_icon
		add_child(background_rect)
		add_child(rect)
		rect.global_position = get_viewport_rect().get_center() + Vector2.from_angle(angle) * 50
		background_rect.global_position = get_viewport_rect().get_center() + Vector2.from_angle(angle) * 50
		
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
