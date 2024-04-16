class_name TextPopup extends VBoxContainer

@onready var target_position : Vector2 = position
@onready var hidden_position : Vector2 = position + Vector2(0, -100)
@onready var title : Label = $Title
@onready var description : Label = $Description

@export var default_timings : Array[float] = [0.5, 3, 0.5]

var queue : Array[QueueItem] = []
var current : QueueItem = null
var time_elapsed : Array[float] = [0, 0, 0]

class QueueItem:
	var t : String
	var d : String
	var c : Color
	var time : Array
	func _init(title : String, description : String, color : Color, timings : Array):
		t = title
		d = description
		c = color
		time = timings.map(func a(x): return float(x))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = hidden_position
	
func add_job(title : String, description : String, color : Color, timings : Array = []):
	if not timings:
		queue.append(QueueItem.new(title, description, color, default_timings))
	else:
		queue.append(QueueItem.new(title, description, color, timings))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if queue:
		if not current:
			current = queue.pop_front()
			title.text = current.t
			title.label_settings.shadow_color = current.c
			description.text = current.d
			time_elapsed = [0, 0, 0]
	
	if current:
		visible = true
		if time_elapsed[0] < current.time[0]:
			time_elapsed[0] += delta
			var factor : float = pow(time_elapsed[0] / current.time[0], 0.6)
			position = lerp(hidden_position, target_position, factor)
		elif time_elapsed[1] < current.time[1]:
			time_elapsed[1] += delta
		elif time_elapsed[2] < current.time[2]:
			time_elapsed[2] += delta
			var factor : float = pow(time_elapsed[2] / current.time[2], 2)
			position = lerp(target_position, hidden_position, time_elapsed[2] / current.time[2])
		else:
			current = null
	else:
		visible = false
