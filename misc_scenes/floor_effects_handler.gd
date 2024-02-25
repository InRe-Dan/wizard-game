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
var floor_map : TileMap
@export var decay_rate : int = 30
@export var resolution_factor : int = 2
@export var decay_amount : float = 0.33
@export var zero_threshold : float = 0.10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func try_decay(i : int, j : int, grid : Array[Array]) -> void:
	var neighbours : int = 0
	neighbours += 1 if grid[max(i - 1, 0)][j] else 0
	neighbours += 1 if grid[min(i + 1, grid.size() - 1)][j] else 0
	neighbours += 1 if grid[i][max(j - 1, 0)] else 0
	neighbours += 1 if grid[i][min(j + 1, grid[0].size() - 1)] else 0
	if neighbours < 4:
		grid[i][j] = max(0, grid[i][j] - decay_amount)
	if neighbours == 0 or grid[i][j] <= zero_threshold:
		# todo remove neighbours if they have no remaining neighbours
		grid[i][j] = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i : int in range(decay_rate):
		var decay_x : int = round(randf() * ice_array[0].size() - 1)
		var decay_y : int = round(randf() * ice_array.size() - 1)
		try_decay(decay_y, decay_x, ice_array)
		# may be redundant
		ice_image.set_pixel(decay_x, decay_y, Color.WHITE * ice_array[decay_y][decay_x])

	ice_texture.update(ice_image)
	($Sprite2D as Sprite2D).texture = ice_texture
	
	
func is_point_in_ice(point : Vector2) -> bool:
	var converted_point : Vector2i = convert_global_to_map(point)
	if 0 > converted_point.x or converted_point.x >= ice_array[0].size():
		return false
	if 0 > converted_point.y or converted_point.y >= ice_array.size():
		return false
	return true if ice_array[converted_point.y][converted_point.x] else false
	
func convert_global_to_map(point : Vector2) -> Vector2i:

	var in_tilemap_space : Vector2 = floor_map.to_local(point)
	var map_top_left : Vector2 = floor_map.map_to_local(floor_map.get_used_rect().position) - Vector2(floor_map.tile_set.tile_size) / 2
	var map_size_pixels : Vector2 = floor_map.get_used_rect().size * floor_map.tile_set.tile_size
	var UV : Vector2 = (in_tilemap_space - map_top_left) / (map_size_pixels)
	var translated : Vector2i = UV * Vector2(ice_array[0].size() - 1, ice_array.size() - 1)
	return translated

func add_ice(point : Vector2, radius : float) -> void:
	var converted_point : Vector2i = convert_global_to_map(point)
	radius = (radius / floor_map.tile_set.tile_size.x) * resolution_factor
	for i : int in range(max(0, floor(converted_point.y - radius)), min(ice_array.size(), ceil(converted_point.y + radius))):
		for j : int in range(max(0, floor(converted_point.x - radius)), min(ice_array[0].size(), ceil(converted_point.x + radius))):
			if Vector2(converted_point.x - j , converted_point.y  - i).length() <= radius:
				ice_array[i][j] = 1.0
				ice_image.set_pixel(j, i, Color.WHITE)

func init_for_room() -> void:
	var level_node : Node2D = get_tree().get_first_node_in_group("level")
	floor_map = level_node.get_node("Floor") as TileMap
	var rect : Rect2i = floor_map.get_used_rect()
	ice_image = Image.create(rect.size.x * resolution_factor, rect.size.y * resolution_factor, false, Image.FORMAT_L8)
	ice_texture = ImageTexture.create_from_image(ice_image)
	for i : int in range(rect.size.y * resolution_factor):
		ice_array.append([])
		for j : int in range(rect.size.x * resolution_factor):
			(ice_array[i] as Array).append(0)
	$Sprite2D.scale = floor_map.tile_set.tile_size / resolution_factor
	$Sprite2D.global_position = floor_map.get_used_rect().position * floor_map.tile_set.tile_size
	
