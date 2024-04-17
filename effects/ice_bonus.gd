class_name IceBonusEffect extends Effect

@export var bonus_per_stack : float = 0.2

var stacks : int = 1

func _init(stacks : int = 1) -> void:
	icon = null
	effect_name = "Ice bonus"
	effect_description = "Ice attacks deal " + str(round(bonus_per_stack * stacks * 100)) + "% more damage!" 
	self.stacks = stacks

func _process(delta : float) -> void:
	pass
	
func handle_event(event : Event) -> Event:
	if event is AddEffectEvent:
		var effect_event : AddEffectEvent = event as AddEffectEvent
		if effect_event.effect is IceBonusEffect:
			stacks += (effect_event.effect as IceBonusEffect).stacks
			effect_name = resource.passive_name + " x" + str(stacks)
			effect_description = "Ice attacks deal " + str(round(bonus_per_stack * stacks * 100)) + "% more damage!"
			updated.emit(self)
			effect_event.effect.queue_free()
			effect_event.queue_free()
			return null

	if event is CreatedProjectileEvent:
		var proj_event : CreatedProjectileEvent = event as CreatedProjectileEvent
		if proj_event.proj.resource.element == EntityResource.EntityElement.Ice:
			var effect : IceBonusEffect = IceBonusEffect.new(stacks)
			proj_event.proj.distribute_signal(AddEffectEvent.new(effect))
		
	if event is HasHitEvent:
		var hit_event : HasHitEvent = event as HasHitEvent
		hit_event.multiplier += (bonus_per_stack * stacks)
		return hit_event
	return event

