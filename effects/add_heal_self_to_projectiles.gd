class_name AddHealSelfToProjectileKillsEffect extends Effect

func _init() -> void:
	icon = preload("res://assets/heal_icon.png")
	effect_name = "Vampirism"
	effect_description = "Heal when killing enemies."

func handle_event(event : Event) -> Event:
	if event.type == event.types.created_projectile:
		var proj_event : CreatedProjectileEvent = event as CreatedProjectileEvent
		var effect : KillActionsEffect = KillActionsEffect.new()
		effect.add_child(HealTargetAction.new(get_parent().parent))
		proj_event.proj.distribute_signal(AddEffectEvent.new(effect))
	return event

