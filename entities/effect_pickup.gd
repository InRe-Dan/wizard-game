class_name EffectPickupEntity extends Entity

@export var item : PassiveResource

var item_to_give : Effect

func _ready() -> void:
	if not item_to_give:
		item_to_give = item.make_effect()
	$ItemSprite.texture = item_to_give.resource.icon
	$PointLight2D.color = item_to_give.resource.glow

func distribute_signal(event : Event) -> void:
	if event.type == event.types.been_interacted:
		var interaction : BeenInteractedEvent = event as BeenInteractedEvent
		if item_to_give:
			interaction.interacter.distribute_signal(AddEffectEvent.new(item_to_give))
		queue_free()
	super(event)
