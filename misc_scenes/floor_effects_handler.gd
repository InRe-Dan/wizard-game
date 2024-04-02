class_name FloorEffectsHandler extends Node2D

@export var decay_rate : float = 0.05
@export var resolution_factor : int = 2
@export var red_circle : GradientTexture2D
@export var blue_circle : GradientTexture2D
@export var green_circle : GradientTexture2D

@onready var effects : Sprite2D = $Effects
@onready var lighting : Sprite2D = $Lighting
@onready var fog : Sprite2D = $Fog

var array_size : Vector2i
var floor_map : TileMap


var rd : RenderingDevice
var input_rid : RID
var output_rid : RID
var uniform_set : RID
var shader : RID
var pipeline : RID
var input_uniform : RDUniform
var output_uniform : RDUniform
var compute_list : int

var current_image : Image
var addition_layer : Image
var mask : Image

var tick : float = 0

func shader_init() -> void:
	effects.texture = ImageTexture.create_from_image(effects.texture.get_image())
	if not rd:
		rd = RenderingServer.create_local_rendering_device()
		var shader_file : RDShaderFile = preload("res://shaders/element_decay.glsl")
		var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()
		print(shader_spirv.compile_error_compute)
		shader = rd.shader_create_from_spirv(shader_spirv)
		pipeline = rd.compute_pipeline_create(shader)
	else:
		rd.sync()
	input_uniform = RDUniform.new()
	output_uniform = RDUniform.new()
	input_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	var format : RDTextureFormat = RDTextureFormat.new()
	format.format = RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM
	format.width = array_size.x
	format.height = array_size.y
	format.usage_bits = \
			RenderingDevice.TEXTURE_USAGE_STORAGE_BIT + \
			RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT + \
			RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT


	input_rid = rd.texture_create(format, RDTextureView.new())
	output_rid = rd.texture_create(format, RDTextureView.new())
	output_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	input_uniform.binding = 0 # this needs to match the "binding" in our shader file
	output_uniform.binding = 1
	input_uniform.add_id(input_rid)
	output_uniform.add_id(output_rid)
	uniform_set = rd.uniform_set_create([input_uniform, output_uniform], shader, 0) # the last parameter (the 0) needs to match the "set" in our shader file
	compute_list = rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rd.compute_list_dispatch(compute_list, array_size.x, array_size.y, 1)
	rd.compute_list_end()

func is_point_in_ice(point : Vector2) -> bool:
	return get_pixel_value(point).g > 0.01
func is_point_in_fire(point : Vector2) -> bool:
	return get_pixel_value(point).r > 0.01
func is_point_in_water(point : Vector2) -> bool:
	return get_pixel_value(point).b > 0.01
func get_pixel_value(point : Vector2) -> Color:
	var converted : Vector2i = convert_global_to_map(point)
	if converted.clamp(Vector2i.ZERO, Vector2i(array_size)) != converted:
		return Color.BLACK
	return current_image.get_pixel(converted.x, converted.y)

func add_ice(point : Vector2, radius : int) -> void:
	add_circle(point, radius, green_circle)
func add_fire(point : Vector2, radius : int) -> void:
	add_circle(point, radius, red_circle)
func add_water(point : Vector2, radius : int) -> void:
	add_circle(point, radius, blue_circle)

func add_circle(point : Vector2, radius : int, circle : GradientTexture2D) -> void:
	var converted : Vector2i = convert_global_to_map(point)
	radius = (resolution_factor * radius) / 16
	circle.width = radius * 2
	circle.height = radius * 2
	addition_layer.blend_rect(circle.get_image(), Rect2i(Vector2i.ZERO, Vector2i(radius * 2, radius * 2)), converted - Vector2i(radius, radius))

func melt_ice(point : Vector2, radius : float) -> void:
	pass

func submit_work() -> void:
	rd.texture_update(input_rid, 0, current_image.get_data())
	var compute_list : int = rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rd.compute_list_dispatch(compute_list, array_size.x, array_size.y, 1)
	rd.compute_list_end()
	rd.submit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if tick < 1.9 / 60:
		tick += delta
		return
	tick = 0
	rd.sync()
	# Read back the data from the buffer
	var output_bytes : PackedByteArray = rd.texture_get_data(output_rid, 0)
	var image : Image = effects.texture.get_image()
	var texture : Texture = effects.texture
	image.set_data(image.get_width(), image.get_height(), false, image.get_format(), output_bytes)
	current_image = image
	effects.texture.update(image)
	current_image.blend_rect_mask(addition_layer, mask, Rect2i(Vector2i.ZERO, array_size), Vector2i.ZERO)
	addition_layer.fill(Color(0, 0, 0, 0))
	submit_work()

func convert_global_to_map(point : Vector2) -> Vector2i:
	var in_tilemap_space : Vector2 = floor_map.to_local(point)
	var map_top_left : Vector2 = floor_map.map_to_local(floor_map.get_used_rect().position)\
								 - Vector2(floor_map.tile_set.tile_size) / 2
	var map_size_pixels : Vector2 = floor_map.get_used_rect().size * floor_map.tile_set.tile_size
	var UV : Vector2 = (in_tilemap_space - map_top_left) / (map_size_pixels)
	var translated : Vector2i = UV * Vector2(array_size.x - 1, array_size.y - 1)
	return translated

func init_for_room() -> void:
	var level_node : Node2D = get_tree().get_first_node_in_group("level")
	floor_map = level_node.get_node("Floor") as TileMap
	var rect : Rect2i = floor_map.get_used_rect()
	array_size = rect.size * resolution_factor
	effects.texture = ImageTexture.create_from_image(Image.create(array_size.x, array_size.y, false, Image.FORMAT_RGBA8))
	lighting.texture = effects.texture
	current_image = effects.texture.get_image()
	addition_layer = effects.texture.get_image().duplicate(true)
	mask = Image.create(array_size.x, array_size.y, false, Image.FORMAT_RGBA8)
	for i : int in range(array_size.y):
		for j : int in range(array_size.x):
			if floor_map.get_cell_tile_data(0, rect.position + Vector2i(j, i) / resolution_factor):
				mask.set_pixel(j, i, Color.WHITE)
			else:
				mask.set_pixel(j, i, Color.TRANSPARENT)
	lighting.texture = effects.texture.duplicate(true)
	effects.scale = floor_map.tile_set.tile_size / resolution_factor
	effects.global_position = floor_map.to_global(floor_map.map_to_local(floor_map.get_used_rect().position)) - Vector2(floor_map.tile_set.tile_size / 2)
	lighting.scale = floor_map.tile_set.tile_size / resolution_factor
	lighting.global_position = floor_map.to_global(floor_map.map_to_local(floor_map.get_used_rect().position)) - Vector2(floor_map.tile_set.tile_size / 2)
	fog.scale = floor_map.tile_set.tile_size / resolution_factor
	fog.global_position = floor_map.to_global(floor_map.map_to_local(floor_map.get_used_rect().position)) - Vector2(floor_map.tile_set.tile_size / 2)
	shader_init()
	
