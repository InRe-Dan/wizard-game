class_name AddHealSelfToProjectileKillsEffect extends Effect

var healing_amount : int = 1
var stacks : int = 1

func _init() -> void:
	icon = preload("res://assets/heal_icon.png")
	effect_name = "Vampirism x" + str(stacks)
	effect_description = "Heal for " +str(healing_amount) + "HP when killing enemies."

func handle_event(event : Event) -> Event:
	if event.type == event.types.add_effect:
		var effect_event : AddEffectEvent = event as AddEffectEvent
		if effect_event.effect is AddHealSelfToProjectileKillsEffect:
			healing_amount += (effect_event.effect as AddHealSelfToProjectileKillsEffect).healing_amount
			stacks += (effect_event.effect as AddHealSelfToProjectileKillsEffect).stacks
			effect_name = "Vampirism" + " x" + str(stacks)
			effect_description = "Heal for " + str(healing_amount) + "HP when killing enemies." 
			updated.emit(self)
			return null
	
	if event.type == event.types.created_projectile:
		var proj_event : CreatedProjectileEvent = event as CreatedProjectileEvent
		var effect : KillActionsEffect = KillActionsEffect.new()
		effect.add_child(HealTargetAction.new(get_parent().parent, healing_amount))
		proj_event.proj.distribute_signal(AddEffectEvent.new(effect))
	return event

