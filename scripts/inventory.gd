class_name Inventory extends Node2D

var items : Array[Item]
var selected : int
var capacity : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	items.append(IceBoltItem.new())
	items.append(FireBallItem.new())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func use_selected(player : Player) -> void:
	if items.size() > 0:
		items[selected].use(player)

func next() -> void:
	selected += 1
	if selected >= items.size():
		selected = 0

func prev() -> void:
	selected -= 1
	if selected < 0:
		selected = items.size() - 1
	
