class_name FloorEffectsHandler extends Node2D

@export var decay_rate : float = 0.05
@export var resolution_factor : int = 2
@export var decay_amount : float = 0.33
@export var zero_threshold : float = 0.1
@export var circle : GradientTexture2D

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
var input_uniform : RDUniform
var output_uniform : RDUniform

var current_image : Image

func shader_init() -> void:
	effects.texture = ImageTexture.create_from_image(effects.texture.get_image())
	rd = RenderingServer.create_local_rendering_device()
	var shader_file : RDShaderFile = preload("res://shaders/element_decay.glsl")
	var shader_spirv: RDShaderSPIRV = shader_file.get_spirv()
	print(shader_spirv.compile_error_compute)
	shader = rd.shader_create_from_spirv(shader_spirv)
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

func is_point_in_ice(point : Vector2) -> bool:
	return false
	
func is_point_in_fire(point : Vector2) -> bool:
	return false
	
func is_point_in_water(point : Vector2) -> bool:
	return false
	
func add_ice(point : Vector2, radius : float) -> void:
	pass

func add_fire(point : Vector2, radius : int) -> void:
	var converted : Vector2i = convert_global_to_map(point)
	radius = (resolution_factor * radius) / 16
	circle.width = radius * 2
	circle.height = radius * 2
	current_image.blit_rect(circle.get_image(), Rect2i(Vector2i.ZERO, Vector2i(radius * 2, radius * 2)), converted - Vector2i(radius, radius))
	
func add_water(W : Vector2, radius : float) -> void:
	pass

func melt_ice(point : Vector2, radius : float) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rd.texture_update(input_rid, 0, current_image.get_data())
	uniform_set = rd.uniform_set_create([input_uniform, output_uniform], shader, 0) # the last parameter (the 0) needs to match the "set" in our shader file
	var pipeline : RID = rd.compute_pipeline_create(shader)
	var compute_list : int = rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rd.compute_list_dispatch(compute_list, array_size.x, array_size.y, 1)
	rd.compute_list_end()
	# Submit to GPU and wait for sync
	rd.submit()
	rd.sync()
	# Read back the data from the buffer
	var output_bytes : PackedByteArray = rd.texture_get_data(output_rid, 0)
	var image : Image = effects.texture.get_image()
	var texture : Texture = effects.texture
	image.set_data(image.get_width(), image.get_height(), false, image.get_format(), output_bytes)
	current_image = image
	effects.texture.update(image)
	lighting.texture.update(image)

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
	current_image = effects.texture.get_image()
	lighting.texture = effects.texture.duplicate(true)
	effects.scale = floor_map.tile_set.tile_size / resolution_factor
	effects.global_position = floor_map.to_global(floor_map.map_to_local(floor_map.get_used_rect().position)) - Vector2(floor_map.tile_set.tile_size / 2)
	lighting.scale = floor_map.tile_set.tile_size / resolution_factor
	lighting.global_position = floor_map.to_global(floor_map.map_to_local(floor_map.get_used_rect().position)) - Vector2(floor_map.tile_set.tile_size / 2)
	fog.scale = floor_map.tile_set.tile_size / resolution_factor
	fog.global_position = floor_map.to_global(floor_map.map_to_local(floor_map.get_used_rect().position)) - Vector2(floor_map.tile_set.tile_size / 2)
	shader_init()
	
