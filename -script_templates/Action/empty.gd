extends Action

func _init(MAKE_SURE_THESE_HAVE_NULL_DEFAULTS : Object = null) -> void:
	pass
func _ready() -> void:
	description = "?"
	expected_cooldown = 0

func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	pass
