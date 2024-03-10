class_name FloorEffectsHandler extends Node2D

@export var decay_rate : float = 0.05
@export var resolution_factor : int = 2
@export var decay_amount : float = 0.33
@export var zero_threshold : float = 0.1

@onready var effects : Sprite2D = $Effects
@onready var lighting : Sprite2D = $Lighting

var ice_array : Array[Array]
var fire_array : Array[Array]
var water_array : Array[Array]
var image : Image
var texture : ImageTexture
var array_size : Vector2i
var floor_map : TileMap

func try_decay(i : int, j : int, grid : Array[Array]) -> void:
	var neighbours : int = 0
	neighbours += 1 if grid[max(i - 1, 0)][j] else 0
	neighbours += 1 if grid[min(i + 1, grid.size() - 1)][j] else 0
	neighbours += 1 if grid[i][max(j - 1, 0)] else 0
	neighbours += 1 if grid[i][min(j + 1, grid[0].size() - 1)] else 0
	if neighbours < 4:
		grid[i][j] = max(0, grid[i][j] - decay_amount)
	if neighbours == 0 or grid[i][j] <= zero_threshold:
		# TODO remove neighbours if they have no remaining neighbours, even if they havent been rolled
		grid[i][j] = 0
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i : int in range(decay_rate * array_size.x * array_size.y):
		var decay_x : int = round(randf() * (array_size.x - 1))
		var decay_y : int = round(randf() * (array_size.y - 1))
		try_decay(decay_y, decay_x, ice_array)
		try_decay(decay_y, decay_x, fire_array)
		try_decay(decay_y, decay_x, water_array)
		var new_col : Color = Color(fire_array[decay_y][decay_x], ice_array[decay_y][decay_x], water_array[decay_y][decay_x])
		image.set_pixel(decay_x, decay_y, new_col)
	
	texture.update(image)
	effects.texture = texture
	lighting.texture = texture
	
	
func is_point_in_ice(point : Vector2) -> bool:
	var converted_point : Vector2i = convert_global_to_map(point)
	if converted_point.clamp(Vector2(0, 0), array_size):
		return false
	if 0 > converted_point.x or converted_point.x >= ice_array[0].size():
		return false
	if 0 > converted_point.y or converted_point.y >= ice_array.size():
		return false
	return true if ice_array[converted_point.y][converted_point.x] else false
	
func convert_global_to_map(point : Vector2) -> Vector2i:
	var in_tilemap_space : Vector2 = floor_map.to_local(point)
	var map_top_left : Vector2 = floor_map.map_to_local(floor_map.get_used_rect().position)\
								 - Vector2(floor_map.tile_set.tile_size) / 2
	var map_size_pixels : Vector2 = floor_map.get_used_rect().size * floor_map.tile_set.tile_size
	var UV : Vector2 = (in_tilemap_space - map_top_left) / (map_size_pixels)
	var translated : Vector2i = UV * Vector2(array_size.x - 1, array_size.y - 1)
	return translated

func add_fire(point : Vector2, radius : float) -> void:
	var converted_point : Vector2i = convert_global_to_map(point)
	radius = (radius / floor_map.tile_set.tile_size.x) * resolution_factor
	for i : int in range(max(0, floor(converted_point.y - radius)), min(array_size.y, ceil(converted_point.y + radius))):
		for j : int in range(max(0, floor(converted_point.x - radius)), min(array_size.x, ceil(converted_point.x + radius))):
			var distance : float = Vector2(converted_point.x - j , converted_point.y  - i).length()
			if distance <= radius:
				water_array[i][j] = max(0.0, water_array[i][j] - pow((1 - distance / radius), 0.3))
				if water_array[i][j] < 0.001:
					fire_array[i][j] = max(pow(1 - distance / radius, 0.3), fire_array[i][j])
					ice_array[i][j] = max(0.0, ice_array[i][j] - fire_array[i][j])
				image.set_pixel(j, i, Color(fire_array[i][j], ice_array[i][j], water_array[i][j]))

func add_water(point : Vector2, radius : float) -> void:
	var converted_point : Vector2i = convert_global_to_map(point)
	radius = (radius / floor_map.tile_set.tile_size.x) * resolution_factor
	for i : int in range(max(0, floor(converted_point.y - radius)), min(ice_array.size(), ceil(converted_point.y + radius))):
		for j : int in range(max(0, floor(converted_point.x - radius)), min(ice_array[0].size(), ceil(converted_point.x + radius))):
			var distance : float = Vector2(converted_point.x - j , converted_point.y  - i).length()
			if distance <= radius:
				if ice_array[i][j] < 0.001:
					water_array[i][j] = max(pow(1 - distance / radius, 0.3), water_array[i][j])
					fire_array[i][j] = 0.0
				image.set_pixel(j, i, Color(fire_array[i][j], ice_array[i][j], water_array[i][j]))

func add_ice(point : Vector2, radius : float) -> void:
	var converted_point : Vector2i = convert_global_to_map(point)
	radius = (radius / floor_map.tile_set.tile_size.x) * resolution_factor
	for i : int in range(max(0, floor(converted_point.y - radius)), min(array_size.y, ceil(converted_point.y + radius))):
		for j : int in range(max(0, floor(converted_point.x - radius)), min(array_size.x, ceil(converted_point.x + radius))):
			var distance : float = Vector2(converted_point.x - j , converted_point.y  - i).length()
			if distance <= radius:
				ice_array[i][j] = max(pow(1 - distance / radius, 0.3), ice_array[i][j])
				water_array[i][j] = 0.0
				fire_array[i][j] = 0.0
				image.set_pixel(j, i, Color(fire_array[i][j], ice_array[i][j], water_array[i][j]))
				
func melt_ice(point : Vector2, radius : float) -> void:
	var converted_point : Vector2i = convert_global_to_map(point)
	radius = (radius / floor_map.tile_set.tile_size.x) * resolution_factor
	for i : int in range(max(0, floor(converted_point.y - radius)), min(array_size.y, ceil(converted_point.y + radius))):
		for j : int in range(max(0, floor(converted_point.x - radius)), min(array_size.x, ceil(converted_point.x + radius))):
			var distance : float = Vector2(converted_point.x - j, converted_point.y - i).length()
			if distance <= radius:
				ice_array[i][j] -= pow(1 - (distance / radius), 2)
				image.set_pixel(j, i, Color(fire_array[i][j], ice_array[i][j], water_array[i][j]))

func init_for_room() -> void:
	var level_node : Node2D = get_tree().get_first_node_in_group("level")
	floor_map = level_node.get_node("Floor") as TileMap
	var rect : Rect2i = floor_map.get_used_rect()
	array_size = rect.size * resolution_factor
	image = Image.create(array_size.x, array_size.y, false, Image.FORMAT_RGB8)
	texture = ImageTexture.create_from_image(image)
	ice_array.clear()
	fire_array.clear()
	water_array.clear()
	for i : int in range(array_size.y):
		ice_array.append([])
		fire_array.append([])
		water_array.append([])
		for j : int in range(array_size.x):
			(ice_array[i] as Array).append(0)
			(fire_array[i] as Array).append(0)
			(water_array[i] as Array).append(0)
	effects.scale = floor_map.tile_set.tile_size / resolution_factor
	effects.global_position = floor_map.to_global(floor_map.map_to_local(floor_map.get_used_rect().position)) - Vector2(floor_map.tile_set.tile_size / 2)
	lighting.scale = floor_map.tile_set.tile_size / resolution_factor
	lighting.global_position = floor_map.to_global(floor_map.map_to_local(floor_map.get_used_rect().position)) - Vector2(floor_map.tile_set.tile_size / 2)
	
