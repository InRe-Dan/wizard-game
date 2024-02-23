class_name FloorEffectsHandler extends Node2D

@onready var fire_collision : Area2D = $Fire
@onready var fire_graphic : Polygon2D = $FireGraphic

@onready var ice_collision : Area2D = $Ice
@onready var ice_graphic : Polygon2D = $IceGraphic

@onready var water_collision : Area2D = $Water
@onready var water_graphic : Polygon2D = $WaterGraphic

enum Elements {ICE, WATER, FIRE}
var erosion_rate : float = 0.25
var erosion : float = -2.5
var erosion_timer : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if erosion_rate < erosion_timer:
		var time1 : float = Time.get_ticks_msec()
		erosion_timer = 0
		var polygons : Array[PackedVector2Array]
		for collision_polygon : CollisionPolygon2D in ice_collision.get_children():
			polygons.append_array(Geometry2D.offset_polygon(collision_polygon.polygon, erosion))
			var convex_hulls : Array[PackedVector2Array]
			for crap_polygon : PackedVector2Array in polygons:
				convex_hulls.append_array(Geometry2D.decompose_polygon_in_convex(crap_polygon))
			var poly : PackedVector2Array = convex_hulls[0]
			for i : int in convex_hulls.size() - 1:
				Geometry2D.merge_polygons(poly, convex_hulls[i + 1])
			collision_polygon.polygon = poly
		
		var time2 : float = Time.get_ticks_msec()
		# print((time2 - time1) / 1000)
	else:
		erosion_timer += delta
	# ice_graphic.polygon = ice_collision.polygon
	
func is_point_in_ice(point : Vector2) -> bool:
	return false
	# return Geometry2D.is_point_in_polygon(point, ice_collision.polygon)
	
func add_polygon(polygon : PackedVector2Array, type : Elements) -> void:
	pass
	
