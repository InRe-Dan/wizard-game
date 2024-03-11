class_name Entity extends CharacterBody2D

enum Team {player, enemy, any}

@export var entity_name : String = "Unnamed Entity"
@export var spawn_velocity : float = 500
@export var health : int = 5
@export_enum("Player", "Enemy", "Any") var team : int = Team.any

var last_move_input : Vector2
var knocked_back_by : Entity = null
var knockback_time : float
const knockback_valid_timer : float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	z_as_relative = false
	z_index = 2
	
func _physics_process(delta: float) -> void:
	pass

func distribute_signal(event : Event) -> void:
	
	for child : Node in get_children():
		if child as EntityComponent:
			event = (child as EntityComponent).receive_signal(event)

	match event.type:
		Event.types.inputmove:
			var move : InputMoveEvent = event as InputMoveEvent
			last_move_input = move.direction
			distribute_signal(AttemptMoveEvent.new(move.direction))
		Event.types.has_hit:
			var hit : HasHitEvent = event as HasHitEvent 
			hit.target.distribute_signal(BeenHitEvent.new(self, hit.damage))
		Event.types.been_hit:
			var hit : BeenHitEvent = event as BeenHitEvent
			if hit.damage.knockback_type == hit.damage.KnockbackTypes.origin:
				distribute_signal(TakeDamageEvent.new(hit.damage, (global_position - hit.dealer.global_position)))
			else:
				distribute_signal(TakeDamageEvent.new(hit.damage, hit.dealer.velocity))
			hit.dealer.distribute_signal(DealtDamageEvent.new(self, hit.damage))
		Event.types.take_damage:
			var hit : TakeDamageEvent = event as TakeDamageEvent
			health -= hit.damage.damage
			if hit.damage.damage > 0:
				match hit.damage.damage_type:
					DamageData.DamageTypes.fire:
						say("-" + str(hit.damage.damage) + "HP", Color.ORANGE_RED * 0.5 + Color.WHITE * 0.5)
					DamageData.DamageTypes.ice:
						say("-" + str(hit.damage.damage) + "HP", Color.CYAN * 0.5 + Color.WHITE * 0.5)
					DamageData.DamageTypes.water:
						say("-" + str(hit.damage.damage) + "HP", Color.SKY_BLUE * 0.5 + Color.WHITE * 0.5)
					DamageData.DamageTypes.kinetic:
						say("-" + str(hit.damage.damage) + "HP", Color.LIGHT_STEEL_BLUE)
			if hit.damage.knockback_velocity > 0.0:
				knockback_time = Time.get_ticks_msec()
				print(entity_name)
				velocity += hit.direction.normalized() * hit.damage.knockback_velocity
			if health <= 0:
				distribute_signal(DeathEvent.new())
				queue_free()
		_:
			pass

	# HACK stops memory leak?
	event.queue_free()
	
func say(text : String, color : Color = Color.WHITE) -> void:
	distribute_signal(SpeechEvent.new(text, color))

