class_name InventoryComponent extends EntityComponent

var selected : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func camel_to_spaced(string : String) -> String:
	return string.to_snake_case().replace("_",  " ").capitalize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func use(direction : Vector2) -> void:
	(get_children()[selected] as InventoryItem).use(parent, direction)

func use_any_attack() -> void:
	pass

func use_any_heal() -> void:
	pass

func cycleItems(amount : int) -> void:
	selected += amount
	if selected < 0:
		selected = get_children().size() - 1
	elif selected >= get_children().size():
		selected = 0
	# parent.say(camel_to_spaced(get_children()[selected].name))

func receive_signal(event : Event) -> Event:
	match event.type:
		Event.types.inputcommand:
			var commandevent : InputCommand = event as InputCommand
			match commandevent.command:
				commandevent.Commands.attack:
					use_any_attack()
				commandevent.Commands.heal:
					use_any_heal()
				commandevent.Commands.use:
					use(commandevent.direction)
				commandevent.Commands.cyclef:
					cycleItems(1)
				commandevent.Commands.cycleb:
					cycleItems(-1)
	return event
