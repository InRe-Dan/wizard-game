class_name FloorEffectsHandler extends Node2D

@onready var fire_collision : Area2D = $Fire
@onready var fire_graphic : Polygon2D = $FireGraphic

@onready var ice_collision : Area2D = $Ice
@onready var ice_graphic : Polygon2D = $IceGraphic

@onready var water_collision : Area2D = $Water
@onready var water_graphic : Polygon2D = $WaterGraphic

enum Elements {ICE, WATER, FIRE}

var ice_array : Array[Array]
var ice_image : Image
var ice_texture : ImageTexture
@export var decay_rate : int = 30
@export var resolution_factor : int = 2
@export var add_ice_chance : float = 0.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if randf() < add_ice_chance:
		FloorHandler.add_ice(Vector2(randf() * ice_array[0].size() / resolution_factor, randf() * ice_array.size() / resolution_factor), randf() * 5 + 2)
	for i : int in range(decay_rate):
		var decay_x : int = randf() * ice_array[0].size()
		var decay_y : int = randf() * ice_array.size()
		ice_array[decay_y][decay_x] = max(0, ice_array[decay_y][decay_x] - 0.33)
		ice_image.set_pixel(decay_x, decay_y, Color.WHITE * ice_array[decay_y][decay_x])
	ice_texture.update(ice_image)
	($Sprite2D as Sprite2D).texture = ice_texture
	
	
func is_point_in_ice(point : Vector2) -> bool:
	return false
	# return Geometry2D.is_point_in_polygon(point, ice_collision.polygon)
	
func add_ice(point : Vector2, radius : int) -> void:
	for i : int in range(max(0, floor(point.y * resolution_factor - radius * resolution_factor)), min(ice_array.size() - 1, ceil(point.y * resolution_factor + radius * resolution_factor))):
		for j : int in range(max(0, floor(point.x * resolution_factor - radius * resolution_factor)), min(ice_array[0].size() - 1, ceil(point.x * resolution_factor + radius * resolution_factor))):
			if Vector2(point.x * resolution_factor - j , point.y * resolution_factor -i).length() <= radius * resolution_factor:
				ice_array[i][j] = 1.0
				ice_image.set_pixel(j, i, Color.WHITE)

func init_for_room() -> void:
	var level_node : Node2D = get_tree().get_first_node_in_group("level")
	var floor : TileMap = level_node.get_node("Floor") as TileMap
	var rect : Rect2i = floor.get_used_rect()
	ice_image = Image.create(rect.size.x * resolution_factor, rect.size.y * resolution_factor, false, Image.FORMAT_L8)
	ice_texture = ImageTexture.create_from_image(ice_image)
	for i : int in range(rect.size.y * resolution_factor):
		ice_array.append([])
		for j : int in range(rect.size.x * resolution_factor):
			(ice_array[i] as Array).append(0)
	
