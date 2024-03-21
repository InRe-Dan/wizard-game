extends HBoxContainer

@export_dir var item_directory : String
@onready var item_select : OptionButton = $ScrollContainer/VBoxContainer/HBoxContainer3/ItemOption
var item_map : Dictionary = Dictionary() # String -> PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ScrollContainer.visible = false
	var dir : DirAccess = DirAccess.open(item_directory)
	if dir:
		var files : PackedStringArray = dir.get_files()
		files.sort()
		var index : int = 0
		for filename : String in files:
			if filename.ends_with(".tres"):
				item_select.add_item(filename.trim_suffix(".tscn"), index)
				item_map[filename.trim_suffix(".tscn")] = load(item_directory + "/" + filename)
				index += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_regen_button_pressed() -> void:
	for child : Node in get_tree().get_nodes_in_group("npcs"):
		child.queue_free()
	(get_tree().get_first_node_in_group("level") as Level).generate_bsp()


func _on_kill_button_pressed() -> void:
	for child : Node in get_tree().get_nodes_in_group("npcs"):
		child.queue_free()


func _on_give_pressed() -> void:
	var player : Entity = get_tree().get_first_node_in_group("players")
	var item : InventoryItem = (item_map[item_select.get_item_text(item_select.get_selected_id())] as ItemResource).make_item()
	player.give(item)


func _on_fullscreen_pressed() -> void:
	var mode : int = get_tree().root.mode
	if mode == Window.MODE_WINDOWED:
		mode = Window.MODE_EXCLUSIVE_FULLSCREEN
	else:
		mode = Window.MODE_WINDOWED
	(get_tree() as SceneTree).root.mode = mode

func _on_tab_toggled(toggled_on: bool) -> void:
	if toggled_on:
		$ScrollContainer.visible = false
		$Tab.text = "<"
	else:
		$ScrollContainer.visible = true
		$Tab.text = ">"


func _on_pause_pressed() -> void:
	get_tree().paused = not get_tree().paused


func _on_override_toggled(toggled_on: bool) -> void:
	if toggled_on:
		get_tree().get_first_node_in_group("players").process_mode = Node.PROCESS_MODE_ALWAYS
	else:
		get_tree().get_first_node_in_group("players").process_mode = Node.PROCESS_MODE_INHERIT
