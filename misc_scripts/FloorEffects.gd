extends Node2D

@onready var fire_collision : CollisionPolygon2D = $Fire/CollisionPolygon2D
@onready var fire_graphic : Polygon2D = $FireGraphic

@onready var ice_collision : CollisionPolygon2D = $Ice/CollisionPolygon2D
@onready var ice_graphic : Polygon2D = $IceGraphic

@onready var water_collision : CollisionPolygon2D = $Water/CollisionPolygon2D
@onready var water_graphic : Polygon2D = $WaterGraphic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	fire_graphic.polygon = fire_collision.polygon
	ice_graphic.polygon = ice_collision.polygon
	water_graphic.polygon = water_collision.polygon
