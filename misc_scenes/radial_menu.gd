class_name RadialMenu extends Control

@onready var time_bar : TextureProgressBar = $TextureProgressBar

@export var unselected_texture : Texture2D
@export var selected_textrure : Texture2D
@export var dot_texture : Texture2D
@export var empty_dot_texture : Texture2D
@export var dot_selected_texture : Texture2D
@export var label_settings : LabelSettings

@export var time_slow_capacity : float = 3.0

var time_slow_juice : float = 0
var center : Vector2

# https://forum.godotengine.org/t/equivalent-of-gamemakerss-function-angle-difference/27163
func angle_difference(angle1 : float, angle2 : float) -> float:
	var diff : float = angle2 - angle1
	return diff if abs(diff) < PI else diff + (TAU * -sign(diff))

func draw_small(inventory : InventoryComponent) -> void:
	var items : Array[InventoryItem] = inventory.get_items()
	var selected : int = 0
	for i : int in range(items.size()):
		var item : InventoryItem = items[i]
		var rect : TextureRect = TextureRect.new()
		var background_rect : TextureRect = TextureRect.new()
		var angle : float = TAU * float(i) / items.size()
		if item:
			rect.texture = dot_texture
			rect.modulate = item.resource.glow
		else:
			rect.texture = empty_dot_texture
		add_child(rect)
		rect.global_position = center - Vector2.ONE * 4 + Vector2.from_angle(angle) * 70
		if i == inventory.selected:
			background_rect.texture = dot_selected_texture
			add_child(background_rect)
			background_rect.global_position = center - Vector2.ONE * 6 + Vector2.from_angle(angle) * 70

func draw_big(inventory : InventoryComponent) -> void:
	var items : Array[InventoryItem] = inventory.get_items()
	var selected : int = 0
	for i : int in range(items.size()):
		var item : InventoryItem = items[i]
		var rect : TextureRect = TextureRect.new()
		var background_rect : TextureRect = TextureRect.new()
		var angle : float = TAU * float(i) / items.size()
		if item:
			rect.texture = item.resource.inventory_icon
			var label : Label = Label.new()
			label.text = item.resource.item_name + "\n"
			if item.resource.limited_use:
				label.text += str(item.uses) + "/" + str(item.resource.item_durability)
			label.label_settings = label_settings
			label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			label.size = Vector2(100, 50)
			if i == inventory.selected:
				label.modulate.a = 0.8
			else:
				label.modulate.a = 0.5
			add_child(label)
			label.global_position = (center - Vector2(50, 25) + Vector2.from_angle(angle) * 70) + Vector2.DOWN * 38
		else:
			rect.texture = null
		add_child(background_rect)
		add_child(rect)
		rect.size *= 2
		rect.global_position = center - Vector2.ONE * 8 + Vector2.from_angle(angle) * 70
		background_rect.global_position = center - Vector2.ONE * 15 + Vector2.from_angle(angle) * 70
		
		var to_mouse : float = (center - get_global_mouse_position()).angle()
		var to_item : float = (center - rect.global_position).angle()
		var diff : float = angle_difference(to_mouse + PI, to_item + PI) * 2
		if - TAU / items.size() < diff and diff < TAU / items.size():
			background_rect.texture = selected_textrure
			selected = i
		else:
			background_rect.texture = unselected_texture
	inventory.selected = selected

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta : float) -> void:
	for child : Node in get_children():
		if child is TextureProgressBar:
			continue
		remove_child(child)
		child.queue_free()
	var player : Entity = get_tree().get_first_node_in_group("players")
	if not player:
		return
	var player_screen_pos : Vector2 = player.get_global_transform_with_canvas().get_origin()
	center = (get_viewport_rect().get_center() + player_screen_pos) / 2
	center = round(center)
	var inventory : InventoryComponent = null
	for node : Node in player.get_children():
		if node is InventoryComponent:
			inventory = node as InventoryComponent
			break
	if not inventory:
		return
	if Input.is_action_pressed("openmenu"):
		time_bar.visible = true
		time_slow_juice -= delta
		if time_slow_juice < 0:
			time_slow_juice = 0
		if time_slow_juice > 0:
			Engine.time_scale = 0.5
		else:
			Engine.time_scale = 1
		draw_big(inventory)
	else:
		Engine.time_scale = 1
		time_bar.visible = false
		time_slow_juice += delta
		if time_slow_juice > time_slow_capacity:
			time_slow_juice = time_slow_capacity
		draw_small(inventory)

	time_bar.global_position = center - Vector2.ONE * time_bar.texture_progress.get_size().x / 2
	time_bar.value = time_slow_juice / time_slow_capacity
