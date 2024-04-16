extends Node

@onready var main : Main = get_tree().get_first_node_in_group("main") 
@onready var level : Level = get_tree().get_first_node_in_group("level")
@onready var popup : TextPopup = get_tree().get_first_node_in_group("popup")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func queue_announcement(title : String, description : String, color : Color, timings : Array = []) -> void:
	popup.add_job(title, description, color, timings)
	
func announce_item(item : ItemResource):
	popup.add_job("Picked up " + item.item_name, item.flavor_text, Color(item.glow.darkened(0.5)))

func announce_passive(passive : PassiveResource) -> void:
	popup.add_job("New Passive!", passive.passive_name + "\n" + passive.passive_menu_description, passive.glow.darkened(0.5))
