class_name BurningMeleeEffect extends Effect

@export var burn_buildup : float = 1
var stacks : int = 1

func handle_event(event : Event) -> Event:
	if event.type == event.types.add_effect:
		var effect_event : AddEffectEvent = event as AddEffectEvent
		if effect_event.effect is BurningMeleeEffect:
			stacks += (effect_event.effect as BurningMeleeEffect).stacks
			burn_buildup = 1 + 0.2 * stacks
			effect_name = resource.passive_name + " x" + str(stacks)
			effect_description = "Inflict " + str(burn_buildup) + " burn on melee attacks."
			updated.emit(self)
			return null

	if event.type == event.types.created_projectile:
		var proj_event : CreatedProjectileEvent = event as CreatedProjectileEvent
		var effect : KillActionsEffect = KillActionsEffect.new()
		effect.add_child(HealTargetAction.new(get_parent().parent, healing_amount))
		proj_event.proj.distribute_signal(AddEffectEvent.new(effect))
	return event

