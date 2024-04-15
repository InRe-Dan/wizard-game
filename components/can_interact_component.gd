class_name CanInteractComponent extends EntityComponent

@export var detection_area : Area2D
@onready var sprite : Sprite2D = $Sprite2D
var entity : Entity

func interactable_found() -> bool:
	return not detection_area.get_overlapping_areas().is_empty()

func _process(delta: float) -> void:
	var area : Area2D = null
	var closest : float = 100000
	for a : Area2D in detection_area.get_overlapping_areas():
		if global_position.distance_to(a.get_parent().parent.global_position) < closest:
			area = a
			closest = global_position.distance_to(a.get_parent().parent.global_position)
	if area:
		entity = area.get_parent().get_parent() as Entity
		if entity:
			print("Hello")
			sprite.visible = true
			sprite.global_position = entity.global_position + Vector2(0, 16)
		else:
			sprite.visible = false
	else:
		entity = null
		sprite.visible = false

func receive_signal(event : Event) -> Event:
	if event.type == event.types.inputcommand:
		var input : InputCommand = event as InputCommand
		if input.Commands.interact == input.command:
			if entity:
				entity.distribute_signal(BeenInteractedEvent.new(parent, - input.direction))
				parent.distribute_signal(HasInteractedEvent.new(entity, input.direction))
	return event
