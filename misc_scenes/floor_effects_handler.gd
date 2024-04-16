class_name FloorEffectsHandler extends Node2D

@export var decay_rate : float = 0.05
@export var resolution_factor : int = 2
@export var decay_amount : float = 0.33
@export var zero_threshold : float = 0.1

@onready var effects : Sprite2D = $Effects
@onready var lighting : Sprite2D = $Lighting
@onready var fog : Sprite2D = $Fog

var ice_array : Array[Array]
var fire_array : Array[Array]
var water_array : Array[Array]
var floor_mask_array : Array[Array]
var fog_array : Array[Array]
var image : Image
var texture : ImageTexture
var fog_image : Image
var fog_texture : ImageTexture
var array_size : Vector2i
var floor_map : TileMap

var thread : Thread = Thread.new()
var wait : bool = true

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
	
func decay() -> void:
	for i : int in range(decay_rate * array_size.x * array_size.y):
		var decay_x : int = round(randf() * (array_size.x - 1))
		var decay_y : int = round(randf() * (array_size.y - 1))
		try_decay(decay_y, decay_x, ice_array)
		try_decay(decay_y, decay_x, fire_array)
		try_decay(decay_y, decay_x, water_array)
		var new_col : Color = Color(fire_array[decay_y][decay_x], ice_array[decay_y][decay_x], water_array[decay_y][decay_x])
		image.set_pixel(decay_x, decay_y, new_col)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if thread.is_started() and not wait:
		thread.wait_to_finish()
	if wait:
		wait = false
	texture.update(image)
	effects.texture = texture
	lighting.texture = texture
	fog_texture.update(fog_image)
	fog.texture = fog_texture
	if not thread.is_started():
		thread.start(decay)
		wait = true
	
func is_point_in_map(point : Vector2, map : Array[Array]) -> bool:
	var converted_point : Vector2i = convert_global_to_map(point)
	if 0 > converted_point.x or converted_point.x >= map[0].size():
		return false
	if 0 > converted_point.y or converted_point.y >= map.size():
		return false
	return true if map[converted_point.y][converted_point.x] > 0.01 else false
	
func is_point_in_ice(point : Vector2) -> bool:
	return is_point_in_map(point, ice_array)
func is_point_in_fire(point : Vector2) -> bool:
	return is_point_in_map(point, fire_array)
func is_point_in_water(point : Vector2) -> bool:
	return is_point_in_map(point, water_array)

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
				if water_array[i][j] < 0.001:
					fire_array[i][j] = max(pow(1 - distance / radius, 0.3), fire_array[i][j]) * floor_mask_array[i][j]
					ice_array[i][j] = 0.0
				image.set_pixel(j, i, Color(fire_array[i][j], ice_array[i][j], water_array[i][j]))

func add_water(point : Vector2, radius : float) -> void:
	var converted_point : Vector2i = convert_global_to_map(point)
	radius = (radius / floor_map.tile_set.tile_size.x) * resolution_factor
	for i : int in range(max(0, floor(converted_point.y - radius)), min(ice_array.size(), ceil(converted_point.y + radius))):
		for j : int in range(max(0, floor(converted_point.x - radius)), min(ice_array[0].size(), ceil(converted_point.x + radius))):
			var distance : float = Vector2(converted_point.x - j , converted_point.y  - i).length()
			if distance <= radius:
				if ice_array[i][j] < 0.001:
					water_array[i][j] = max(pow(1 - distance / radius, 0.3), water_array[i][j]) * floor_mask_array[i][j]
					fire_array[i][j] = 0.0
				image.set_pixel(j, i, Color(fire_array[i][j], ice_array[i][j], water_array[i][j]))

func add_ice(point : Vector2, radius : float) -> void:
	var converted_point : Vector2i = convert_global_to_map(point)
	radius = (radius / floor_map.tile_set.tile_size.x) * resolution_factor
	for i : int in range(max(0, floor(converted_point.y - radius)), min(array_size.y, ceil(converted_point.y + radius))):
		for j : int in range(max(0, floor(converted_point.x - radius)), min(array_size.x, ceil(converted_point.x + radius))):
			var distance : float = Vector2(converted_point.x - j , converted_point.y  - i).length()
			if distance <= radius:
				if fire_array[i][j] < 0.01:
					ice_array[i][j] = max(pow(1 - distance / radius, 0.3), ice_array[i][j]) * floor_mask_array[i][j]
					water_array[i][j] = 0.0
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

func clear(point : Vector2, radius : float) -> void:
	var converted_point : Vector2i = convert_global_to_map(point)
	radius = (radius / floor_map.tile_set.tile_size.x) * resolution_factor
	for i : int in range(max(0, floor(converted_point.y - radius)), min(array_size.y, ceil(converted_point.y + radius))):
		for j : int in range(max(0, floor(converted_point.x - radius)), min(array_size.x, ceil(converted_point.x + radius))):
			var distance : float = Vector2(converted_point.x - j, converted_point.y - i).length()
			if distance <= radius:
				ice_array[i][j] -= 0
				water_array[i][j] = 0
				fire_array[i][j] = 0
				image.set_pixel(j, i, Color.BLACK)

func clear_fog(point : Vector2, radius : float) -> void:
	var converted_point : Vector2i = convert_global_to_map(point)
	radius = (radius / floor_map.tile_set.tile_size.x) * resolution_factor
	for i : int in range(max(0, floor(converted_point.y - radius)), min(array_size.y, ceil(converted_point.y + radius))):
		for j : int in range(max(0, floor(converted_point.x - radius)), min(array_size.x, ceil(converted_point.x + radius))):
			var distance : float = Vector2(converted_point.x - j, converted_point.y - i).length()
			if distance <= radius:
				if true or floor_mask_array[i][j]:
					fog_array[i][j] = max(pow(1 - (distance / radius), 0.1), fog_array[i][j])
					fog_image.set_pixel(j, i, Color(1, 1, 1, clamp(1 - fog_array[i][j], 0, 1)))

func init_for_room() -> void:
	var level_node : Node2D = get_tree().get_first_node_in_group("level")
	floor_map = level_node.get_node("Floor") as TileMap
	var rect : Rect2i = floor_map.get_used_rect()
	array_size = rect.size * resolution_factor
	image = Image.create(array_size.x, array_size.y, false, Image.FORMAT_RGB8)
	texture = ImageTexture.create_from_image(image)
	fog_image = Image.create(array_size.x, array_size.y, false, Image.FORMAT_RGBA8)
	fog_texture = ImageTexture.create_from_image(fog_image)
	ice_array.clear()
	fire_array.clear()
	water_array.clear()
	fog_array.clear()
	floor_mask_array.clear()
	for i : int in range(array_size.y):
		ice_array.append([])
		fire_array.append([])
		water_array.append([])
		fog_array.append([])
		floor_mask_array.append([])
		for j : int in range(array_size.x):
			ice_array[i].append(0)
			fire_array[i].append(0)
			water_array[i].append(0)
			fog_array[i].append(0)
			fog_image.set_pixel(j, i, Color(1, 1, 1, 1))
			if floor_map.get_cell_tile_data(0, rect.position + Vector2i(j, i) / resolution_factor):
				floor_mask_array[i].append(1)
			else:
				floor_mask_array[i].append(0)
			
	effects.scale = floor_map.tile_set.tile_size / resolution_factor
	effects.global_position = floor_map.to_global(floor_map.map_to_local(floor_map.get_used_rect().position)) - Vector2(floor_map.tile_set.tile_size / 2)
	lighting.scale = floor_map.tile_set.tile_size / resolution_factor
	lighting.global_position = floor_map.to_global(floor_map.map_to_local(floor_map.get_used_rect().position)) - Vector2(floor_map.tile_set.tile_size / 2)
	fog.scale = floor_map.tile_set.tile_size / resolution_factor
	fog.global_position = floor_map.to_global(floor_map.map_to_local(floor_map.get_used_rect().position)) - Vector2(floor_map.tile_set.tile_size / 2)
	
