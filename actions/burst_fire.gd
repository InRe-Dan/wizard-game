class_name BurstFireAction extends Action

@export var projectile_resource : EntityResource
@export var shots : int = 3
@export var delay : float = 0.1

var caller : Entity
var in_progress : bool = false
var timer : float
var shots_fired : int

func _ready() -> void:
	description = "Fire a burst of " + projectile_resource.entity_name + "s"
	expected_cooldown = shots * delay

func _process(delta : float) -> void:
	if not in_progress:
		return
	timer += delta
	var required_shots : int = ceil(timer / delay)
	for i : int in range(required_shots - shots_fired):
		var projectile : Entity = projectile_resource.make_entity()
		projectile.global_position = caller.global_position
		projectile.velocity = projectile_resource.spawn_velocity * (caller.looking_at - caller.global_position).normalized()
		caller.distribute_signal(CreatedProjectileEvent.new(projectile))
		get_tree().get_first_node_in_group("level").add_child(projectile)
		shots_fired += 1
	if shots_fired == shots:
		finished.emit()
		in_progress = false

func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	if not in_progress:
		in_progress = true
		caller = target
		timer = 0
		shots_fired = 0
	

