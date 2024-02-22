class_name DialogueLabel extends Label

var lifetime : float
var speed : float

var time : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if time > lifetime:
		queue_free()
	position.y -= speed * delta
