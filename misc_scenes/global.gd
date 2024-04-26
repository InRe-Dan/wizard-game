extends Node

@onready var main : Main = get_tree().get_first_node_in_group("main") 
@onready var level : Level = get_tree().get_first_node_in_group("level")
@onready var popup : TextPopup = get_tree().get_first_node_in_group("popup")
@onready var camera : CustomCamera = get_tree().get_first_node_in_group("camera")
@onready var score_label : Label = get_tree().get_first_node_in_group("scorelabel")

var score : int = 0
var last_score_time : float = 0
var floor_number : int = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	last_score_time += delta
	score_label.text = "Score: " + str(score)
	if last_score_time < 1:
		score_label.modulate = Color.YELLOW
	else:
		score_label.modulate = Color.WHITE
	
func queue_announcement(title : String, description : String, color : Color, timings : Array = []) -> void:
	popup.add_job(title, description, color, timings)
	
func announce_item(item : ItemResource):
	popup.add_job("Picked up " + item.item_name, item.flavor_text, Color(item.glow.darkened(0.5)))

func announce_passive(passive : PassiveResource) -> void:
	popup.add_job("New Passive!", passive.passive_name + "\n" + passive.passive_menu_description, passive.glow.darkened(0.5))

func add_score(amount : int, entity : Entity = null) -> void:
	if amount == 0:
		return
	score += amount
	last_score_time = 0
	if entity:
		DialogueHandler.floating_text("+" + str(amount), Color.YELLOW, entity.global_position)
	
func clear_score() -> void:
	score = 0
