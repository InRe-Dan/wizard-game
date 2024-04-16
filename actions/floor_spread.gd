class_name FloorSpreadAction extends Action

enum Mode {UNDEFINED, ICE, FIRE, WATER, MELT, CLEANSE}

@export var mode : Mode
@export var radius : float = -1

var init_mode : Mode
var init_rad : float

var runtime : float = 0
var pos : Vector2
var going : bool = false

func _init(mode : Mode = Mode.UNDEFINED, radius : float = -1) -> void:
	init_mode = mode
	init_rad = radius

func _ready() -> void:
	if init_mode != Mode.UNDEFINED:
		mode = init_mode
	if init_rad >= 0:
		radius = init_rad
	match mode:
		Mode.UNDEFINED:
			description = "Does nothing"
		Mode.ICE:
			description = "Spreads ice on the ground"
		Mode.FIRE:
			description = "Spreads fire on the ground"
		Mode.WATER:
			description = "Spreads water on the ground"
		Mode.CLEANSE:
			description = "Cleanses the area"
	expected_cooldown = 0.5
	
func _process(delta: float) -> void:
	if going:
		var scale = runtime / 0.5
		match mode:
			Mode.UNDEFINED:
				pass
			Mode.ICE:
				FloorHandler.add_ice(pos, radius * scale)
			Mode.WATER:
				FloorHandler.add_water(pos, radius * scale)
			Mode.FIRE:
				FloorHandler.add_fire(pos, radius * scale)
			Mode.CLEANSE:
				FloorHandler.clear(pos, radius * scale)
			Mode.MELT:
				FloorHandler.melt_ice(pos, radius * scale)
		runtime += delta
	if runtime > 0.5 and going:
		going = false
		finished.emit()

func do(target : Entity, secondary : Entity = null, direction : Vector2 = Vector2.ZERO) -> void:
	pos = target.global_position
	runtime = 0
	going = true

