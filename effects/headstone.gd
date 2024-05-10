class_name HeadstoneEffect extends Effect

var ice_block : EntityResource = preload("res://resources/entities/ice_block.tres")
var stacks : int = 1

func _init(stacks : int = 1) -> void:
	self.stacks = stacks
	icon = null
	effect_name = "Headstone"
	effect_description = "Enemies killed with ice have a chance to be turned into iceblocks."

func handle_event(event : Event) -> Event:
	var kill : HasKilledEvent = event as HasKilledEvent
	if kill:
		if kill.target.resource.type == EntityResource.EntityType.Enemy:
			if randf() > pow(0.9, stacks):
				var block : Entity = ice_block.make_entity()
				block.global_position = kill.target.global_position
				Global.level.add_child(block)
				get_parent().parent.distribute_signal.call_deferred(CreatedProjectileEvent.new(block))

	var creation : CreatedProjectileEvent = event as CreatedProjectileEvent
	if creation:
		if creation.proj.resource.element == EntityResource.EntityElement.Ice:
			var new_effect : HeadstoneEffect = HeadstoneEffect.new(stacks)
			creation.proj.distribute_signal(AddEffectEvent.new(new_effect))
	var addition : AddEffectEvent = event as AddEffectEvent
	if addition:
		var effect : HeadstoneEffect = addition.effect as HeadstoneEffect
		if effect:
			stacks += effect.stacks
			return null
	return event

