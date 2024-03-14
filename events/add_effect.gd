class_name AddEffectEvent extends Event

var effect : Effect

func _init(effect_to_add : Effect) -> void:
	type = types.add_effect
	effect = effect_to_add

