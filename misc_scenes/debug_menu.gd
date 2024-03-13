extends ScrollContainer

@export_dir var item_directory : String
@onready var item_select : OptionButton = $VBoxContainer/HBoxContainer3/ItemOption
var item_map : Dictionary = Dictionary() # String -> PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var dir : DirAccess = DirAccess.open(item_directory)
	if dir:
		var files : PackedStringArray = dir.get_files()
		var index : int = 0
		for filename : String in files:
			if filename.ends_with(".tscn"):
				item_select.add_item(filename, index)
				item_map[filename] = load(item_directory + "/" + filename)
				index += 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_regen_button_pressed() -> void:
	for child : Node in get_tree().get_nodes_in_group("npcs"):
		child.queue_free()
	(get_tree().get_first_node_in_group("level") as Level).generate(10)


func _on_kill_button_pressed() -> void:
	for child : Node in get_tree().get_nodes_in_group("npcs"):
		child.queue_free()


func _on_give_pressed() -> void:
	(get_tree().get_first_node_in_group("players") as Entity).give(item_map[item_select.get_item_text(item_select.get_selected_id())].instantiate())
