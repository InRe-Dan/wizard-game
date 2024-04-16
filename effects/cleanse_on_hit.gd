class_name CleanseOnHitEffect extends Effect

var action : FloorSpreadAction = FloorSpreadAction.new(FloorSpreadAction.Mode.CLEANSE, 48)
var stacks : int = 1

func _init() -> void:
	icon = null
	effect_name = "Cleanse on Hit"
	effect_description = "When taking damage, the floor around you is cleansed."

func _ready() -> void:
	add_child(action)

func _process(delta : float) -> void:
	pass
	
func handle_event(event : Event) -> Event:
	if event is TakeDamageEvent:
		action.do(parent)
	if event is AddEffectEvent:
		if (event as AddEffectEvent).effect is CleanseOnHitEffect:
			stacks += ((event as AddEffectEvent).effect as CleanseOnHitEffect).stacks
			action.radius = 48 + 16 * (stacks - 1)
			return null
	return event

