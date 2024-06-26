class_name SwingAction extends Action

@export var entity_resource : EntityResource
@export var swing_angle : float = 90
@export var swing_distance : float = 24
@export var swing_angular_speed : float = 360
@export var alternate : bool = true

var orbit_entity : Entity
var entity : Entity

var swinging : bool = false
var start_angle : float
var swing_time : float
var time_passed : float
var modifier : float = 1

func move_to_orbit_location() -> void:
	entity.rotation_degrees = (start_angle + modifier * swing_angle * time_passed / swing_time) + 90
	entity.global_position = orbit_entity.global_position + swing_distance * Vector2.from_angle(deg_to_rad(entity.rotation_degrees - 90))

func _ready() -> void:
	var entity : Entity = entity_resource.make_entity() as Entity
	description = "Swing " + a_or_an(entity.resource.entity_name) + " in front of you"
	expected_cooldown = swing_angle / swing_angular_speed
	entity.queue_free()

func _process(delta : float) -> void:
	if swinging:
		time_passed += delta
		move_to_orbit_location()
		if time_passed > swing_time:
			swinging = false
			remove_child(entity)
			entity.queue_free()
			finished.emit()

func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	if not swinging:
		entity = entity_resource.make_entity() as Entity
		add_child(entity)
		target.distribute_signal(CreatedProjectileEvent.new(entity))
		orbit_entity = target
		entity.team = orbit_entity.team
		if alternate:
			modifier *= -1
			entity.get_node("Sprite2D").flip_h = false if modifier > 0 else true
		else:
			modifier = -1 if abs(direction.angle_to(Vector2.LEFT)) < PI/2 else 1
		start_angle = rad_to_deg(direction.angle()) + -1 * modifier * swing_angle / 2
		swinging = true
		time_passed = 0
		swing_time = swing_angle / swing_angular_speed

