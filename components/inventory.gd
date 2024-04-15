class_name InventoryComponent extends EntityComponent

@export var starting_items : Array[ItemResource]
@export var default_item : ItemResource

var selected : int = 0

@onready var active : Node = $Active
@onready var consumed : Node = $Consumed

var slots : Array[InventoryItem] = [null, null, null, null, null, null, null, null]
var slot_times : Array[float] = [0, 0, 0, 0, 0, 0, 0, 0]
var default : InventoryItem

func _ready() -> void:
	if default_item:
		default = default_item.make_item()
		default.resource = default.resource.duplicate()
		default.resource.limited_use = false
		add_child(default)
	var i : int = 0
	for resource : ItemResource in starting_items:
		var item : InventoryItem = resource.make_item()
		active.add_child(item)
		slots[i] = item
		i += 1
	
func _process(delta : float) -> void:
	for slot : float in slot_times:
		slot += delta

func get_selected() -> InventoryItem:
	return slots[selected]

func use(direction : Vector2) -> void:
	var item : InventoryItem = get_selected()
	if item:
		if item.is_ready():
			if item.use(parent, direction):
				active.remove_child(item)
				consumed.add_child(item)
				slots[selected] = null
				cycleItems(-1)
				parent.distribute_signal(ItemConsumedEvent.new(item))
	else:
		if not default:
			pass
		elif default.is_ready():
			default.use(parent, direction)

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

func discard(slot : int) -> void:
	var item : InventoryItem = slots[slot]
	if item:
		item.queue_free()
		slots[slot] = null
		slot_times[slot] = 0
		parent.distribute_signal(ItemConsumedEvent.new(item))

func get_items() -> Array[InventoryItem]:
	return slots.duplicate()

func add_item(item : InventoryItem) -> void:
	var usable_slot : int = slots.find(null)
	if usable_slot == -1:
		var longest_time : float = 0
		for i : int in range(slots.size()):
			if longest_time < slot_times[i]:
				usable_slot = i
				longest_time = slot_times[i]
		discard(usable_slot)
	active.add_child(item)
	slots[usable_slot] = item
	slot_times[usable_slot] = 0

func select(slot : int) -> void:
	selected = slot

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
				commandevent.Commands.consume:
					discard(selected)
	return event
