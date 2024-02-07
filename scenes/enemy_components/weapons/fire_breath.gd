extends EnemyWeapon

@export var projectile : PackedScene;
@export var projectile_count : int = 3
@export var spread : float = 20
@export var shot_delay : float = 0.1


@onready var cooldown : Timer = $Cooldown

var time_since_fired : float = 0.0
var firing : bool = false
var shots_fired : int = 0
var targeting : Vector2
var weapon_user : Enemy


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	effective_range = 100000


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if firing:
		if shots_fired >= projectile_count:
			firing = false
			return
		time_since_fired += delta
		var projectiles_to_fire : int = max(0, floor(time_since_fired / shot_delay) - shots_fired)
		for i : int in range(projectiles_to_fire):
			var proj : Projectile = projectile.instantiate() as Projectile
			proj.set_attributes(weapon_user.global_position.direction_to(targeting), weapon_user.global_position)
			(get_tree().get_first_node_in_group("main") as Main).add_child(proj)
	
func use(user : Enemy, target : Vector2) -> void:
	if cooldown.is_stopped():
		weapon_user = user
		targeting = target
		print("Use fire breath")
		time_since_fired = 0.0
		firing = true
		shots_fired = 0
		cooldown.start()
