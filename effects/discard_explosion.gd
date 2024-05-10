class_name DiscardExplosionEffect extends Effect

var stacks : int = 1
var explosion : EntityResource = preload("res://resources/entities/death_blast.tres")

func _init() -> void:
	icon = null
	effect_name = "Mana Overflow"
	effect_description = "Discarding spells causes you to explode!"

func do() -> void:
	for i : int in range(stacks):
		var entity : Entity = explosion.make_entity()
		entity.team = get_parent().parent.team
		add_child(entity)
		entity.global_position = get_parent().parent.global_position

func handle_event(event : Event) -> Event:
	var add : AddEffectEvent = event as AddEffectEvent
	if add:
		var discard : DiscardExplosionEffect = add.effect as DiscardExplosionEffect
		if discard:
			stacks += discard.stacks
			return null
	var consumed : ItemConsumedEvent = event as ItemConsumedEvent
	if consumed:
		do()
	return event

