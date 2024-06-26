extends Node2D

var labels : Array[LabelManager]
@export var label_material : CanvasItemMaterial
@export var label_settings : LabelSettings = LabelSettings.new()

class LabelManager extends RefCounted:
	func _init() -> void:
		assert(false)
	func process(delta : float) -> bool:
		assert(false)
		return false

class ThrownLabel extends LabelManager:
	var l : Label
	var gravity : float = 50
	var velocity : Vector2
	var lifetime : float = 0.5
	func _init(label : Label, entity : Entity) -> void:
		l = label
		l.global_position = entity.global_position - (l.size / 2)
		velocity = 30 * Vector2.UP.rotated((randf() - 0.5) * PI)
	func process(delta : float) -> bool:
		lifetime -= delta
		velocity += Vector2(0, gravity * delta)
		l.global_position += velocity * delta
		if lifetime < 0:
			l.queue_free()
			return true
		return false

class FloatingLabel extends LabelManager:
	var l : Label
	var velocity = 10
	var lifetime : float = 1
	func _init(label : Label, pos : Vector2) -> void:
		l = label
		l.global_position = pos
	func process(delta : float) -> bool:
		lifetime -= delta
		l.global_position.y -= velocity * delta
		if lifetime < 0:
			l.queue_free()
			return true
		return false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func make_new(text : String) -> Label:
	var label : Label = Label.new()
	label.label_settings = label_settings.duplicate()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.z_index = 10
	label.z_as_relative = false
	label.text = text
	label.material = label_material
	return label
	
	
func say(entity : Entity, speech : SpeechEvent):
	var label : Label = make_new(speech.text)
	label.label_settings.font_color = speech.color
	labels.append(ThrownLabel.new(label, entity))
	add_child(label)

func floating_text(text : String, color : Color, pos : Vector2):
	var label : Label = make_new(text)
	label.label_settings.font_color = color
	labels.append(FloatingLabel.new(label, pos))
	add_child(label)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_labels : Array[LabelManager] = []
	for label : LabelManager in labels:
		if not label.process(delta):
			new_labels.append(label)
	labels = new_labels
