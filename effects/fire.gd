class_name FireEffect extends Effect

@export var apply_immunity : bool = false

var buildup : float = 0
@export var seconds_threshold : float = 0.5
@export var immunity : float = 0.5
@export var tick_damage : DamageData
var immunity_frames : float

func _init() -> void:
	if not tick_damage:
		tick_damage = DamageData.new()
		tick_damage.damage = 1
		tick_damage.damage_type = tick_damage.DamageTypes.fire

func _ready() -> void:
	icon = preload("res://assets/fire_icon.png")
	effect_name = "On fire!"
	effect_description = "You're on fire! Take " + str(tick_damage.damage * 1 / immunity) + " DPS!"

func _process(delta : float) -> void:
	if not apply_immunity:
		var entity : Entity = (get_parent() as EntityComponent).parent
		if FloorHandler.is_point_in_fire(entity.global_position):
			buildup += delta
		elif buildup > 0.0:
			buildup -= min(delta * 2, buildup)
		if buildup > 1.0 and immunity_frames < 0.01:
			entity.distribute_signal(TakeDamageEvent.new(tick_damage, Vector2.ZERO, 1.0))
			immunity_frames = immunity
		if immunity_frames > 0:
			immunity_frames -= delta
		if buildup > seconds_threshold and not is_visible:
			is_visible = true
			updated.emit(self)
		if buildup < seconds_threshold and is_visible:
			is_visible = false
			updated.emit(self)

func handle_event(event : Event) -> Event:
	if event is AddEffectEvent:
		var effect_event : AddEffectEvent = event as AddEffectEvent
		if effect_event.effect is FireEffect:
			var effect : FireEffect = effect_event.effect as FireEffect
			if effect.apply_immunity:
				apply_immunity = true
			else:
				buildup = effect.buildup
			return null
	return event
