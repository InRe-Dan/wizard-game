class_name CooldownAction extends Action

@export var cooldown_time : float = 0.3

var timer : float = 0
var processing : bool = false

func _ready() -> void:
	description = ""
	expected_cooldown = cooldown_time

func _process(delta : float) -> void:
	if processing:
		timer += delta
		if timer > cooldown_time:
			finished.emit()
			processing = false

func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	processing = true
	timer = 0

