extends EntityComponent

@export var show_duration : float = 0.5
@export var fade_duration : float = 0.2
@export var change_speed : float = 2

@onready var bar : TextureProgressBar = $TextureProgressBar

var offset_to_parent : Vector2
var target_value : float = 1
var time_since_hit : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	offset_to_parent = position
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = round(parent.global_position + offset_to_parent)
	target_value = parent.health / parent.resource.starting_health
	var change : float = (change_speed * -1 * delta if bar.value > target_value else change_speed * 1 * delta)
	if abs(change) < 0.01:
		change = 0
	bar.value += change
	if visible:
		time_since_hit += delta
		if time_since_hit > show_duration:
			if time_since_hit < show_duration + fade_duration:
				modulate = Color(1, 1, 1, 1 - (time_since_hit - show_duration) / (fade_duration))
			else:
				visible = false
func receive_signal(event : Event) -> Event:
	if event is TakeDamageEvent or event is HealedEvent:
		print(parent.health)
		visible = true
		time_since_hit = 0
		modulate = Color.WHITE
	return event

