class_name ProjectileDespawnerComponent extends EntityComponent

@export var despawn_on_standstill : bool = false
@export var despawn_after_interval : bool = false
@export var lifetime : float = 1
@export var piercing : bool = false
@export var kill_on_collision : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if despawn_on_standstill:
		if parent.velocity.length() < 20:
			parent.distribute_signal(DeathEvent.new())
	if despawn_after_interval:
		lifetime -= delta
		if lifetime < 0:
			parent.distribute_signal(DeathEvent.new())

func receive_signal(event : Event) -> Event:
	match event.type:
		Event.types.collision:
			if kill_on_collision:
				parent.distribute_signal(DeathEvent.new())
		Event.types.dealt_damage:
			if not piercing:
				parent.distribute_signal(DeathEvent.new())
	return event
