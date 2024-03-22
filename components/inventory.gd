class_name InventoryComponent extends EntityComponent

@export var starting_items : Array[ItemResource]

var selected : int = 0

@onready var active : Node = $Active
@onready var consumed : Node = $Consumed

func _ready() -> void:
	for resource : ItemResource in starting_items:
		active.add_child(resource.make_item())

func get_selected() -> InventoryItem:
	if active.get_child_count() == 0:
		return null
	return active.get_children()[selected] as InventoryItem

func get_items() -> Array:
	return active.get_children()

func use(direction : Vector2) -> void:
	var item : InventoryItem = get_selected()
	if item:
		if item.is_ready():
			if item.use(parent, direction):
				active.remove_child(item)
				consumed.add_child(item)
				cycleItems(-1)

func use_any_attack() -> void:
	pass

func use_any_heal() -> void:
	pass
	
func use_random() -> void:
	pass
	
func get_item_cooldown_progress() -> float:
	var item : InventoryItem = get_selected()
	if item:
		if item.expected_cooldown == 0:
			return 0
		return min(1, item.time_since_used / item.expected_cooldown)
	return 0

func add_item(item : InventoryItem) -> void:
	active.add_child(item)

func cycleItems(amount : int) -> void:
	selected += amount
	if selected < 0:
		selected = active.get_children().size() - 1
	elif selected >= active.get_children().size():
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
