extends Action

@export var projectile : EntityResource
@export var shot_delay : float = 0.03
@export var shot_count : int = 15
@export var cast_distance : float = 36

var angle_change : float
var time_elapsed : float
var duration : float
var pos : Vector2
var firing : bool = false
var shots_fired : int
var caster : Entity
var start_angle : float

func _ready() -> void:
	description = "Cast " + projectile.entity_name + " all around you"

func _process(delta : float) -> void:
	if not firing:
		return
	time_elapsed += delta
	var shots_that_should_have_fired : int = shot_count
	if shot_delay > 0:
		shots_that_should_have_fired = ceil(time_elapsed / shot_delay)
	var shots_to_fire : int = shots_that_should_have_fired - shots_fired
	for i : int in range(shots_to_fire):
		for j : float in [-0.5, 0.5]:
			var direction : Vector2 = Vector2.from_angle(PI + (start_angle + j * angle_change * (shots_fired)))
			var entity_instance : Entity = projectile.make_entity() as Entity
			entity_instance.velocity = projectile.spawn_velocity * direction
			entity_instance.global_position = pos + direction * cast_distance
			entity_instance.team = caster.team
			var call : Callable = get_tree().get_first_node_in_group("main").add_child
			call.call_deferred(entity_instance)
			caster.distribute_signal(CreatedProjectileEvent.new(entity_instance))
		shots_fired += 1
	if time_elapsed > duration:
		firing = false
		finished.emit()


func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	if not firing:
		firing = true
		pos = target.global_position
		time_elapsed = 0
		angle_change = TAU / shot_count
		duration = shot_delay * shot_count
		shots_fired = 0
		caster = target
		start_angle = direction.angle()
		# jank
		if shot_delay == 0:
			_process(1.0)
	

