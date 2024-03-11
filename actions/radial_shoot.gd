extends Action

@export var projectile : PackedScene
@export var shot_delay : float = 0.03
@export var shot_count : int = 15
@export var cast_distance : float = 36

var angle_change : float
var time_elapsed : float
var duration : float
var position : Vector2
var firing : bool = false
var shots_fired : int
var caster : Entity
var start_angle : float

func _process(delta : float) -> void:
	if not firing:
		return
	time_elapsed += delta
	var shots_that_should_have_fired : int = ceil(time_elapsed / shot_delay)
	var shots_to_fire : int = shots_that_should_have_fired - shots_fired
	for i : int in range(shots_to_fire):
		for j : float in [-0.5, 0.5]:
			var direction : Vector2 = Vector2.from_angle(PI + (start_angle + j * angle_change * (shots_fired)))
			var entity_instance : Entity = projectile.instantiate() as Entity
			entity_instance.velocity = entity_instance.spawn_velocity * direction
			entity_instance.global_position = position + direction * cast_distance
			entity_instance.team = caster.team
			get_tree().get_first_node_in_group("main").add_child(entity_instance)
			caster.distribute_signal(CreatedProjectileEvent.new(entity_instance))
		shots_fired += 1
	if time_elapsed > duration:
		firing = false


func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	if not firing:
		firing = true
		position = target.global_position
		time_elapsed = 0
		angle_change = TAU / shot_count
		duration = shot_delay * shot_count
		shots_fired = 0
		caster = target
		start_angle = direction.angle()
	

