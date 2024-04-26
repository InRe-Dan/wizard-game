class_name Level extends Node2D

@export_category("Room settings")
@export var level_min_size : Vector2i = Vector2i(30, 30)
@export var level_max_size : Vector2i = Vector2i(60, 60)
@export var hallway_width : int = 3
@export var room_min_size : Vector2i
@export var room_max_size : Vector2i
@export_category("Enemy generation")
@export var enemy_list : Array[EntityResource]
@export var min_enemies_per_room : int = 0
@export var max_enemies_per_room : int = 3
@export_category("Item generation")
@export var item_list : Array[ItemResource]
@export var passive_list : Array[PassiveResource]
@export var min_items_per_room : int = 0
@export var max_items_per_room : int = 3

@onready var floor : TileMap = $Floor
@onready var walls : TileMap = $Walls
var stairs_res : EntityResource = load("res://resources/entities/stairs.tres")

signal regenerated

var current_rooms : Array[LevelUtilities.Room]
var layouts : Array[TileMap]
var path_length : int
var graph_data : LevelUtilities.GraphData

func _ready() -> void:
	var files : PackedStringArray = DirAccess.get_files_at("res://room_blueprints/")
	for file : String in files:
		layouts.append(load("res://room_blueprints/" + file).instantiate())

func set_floor(v : Vector2i) -> void:
	if not floor.get_cell_tile_data(0, v):
		floor.set_cell(0, v, 58, Vector2i(range(0, 8).pick_random(), 0))
func set_wall(v : Vector2i) -> void:
	if not walls.get_cell_tile_data(0, v):
		walls.set_cell(0, v, 0, Vector2i(range(4, 8).pick_random(), 4))

func put_rooms_on_tilemap(rooms : Array[LevelUtilities.Room]) -> void:
	for room : LevelUtilities.Room in rooms:
		for i : int in range(room.rect.size.y):
			for j : int in range(room.rect.size.x):
				set_floor(room.rect.position + Vector2i(j, i))
	
func fill_with_walls() -> void:
	var floor_rect : Rect2i = floor.get_used_rect()
	var walls_corner : Vector2i = Vector2i(floor_rect.position - 3 * Vector2i.ONE)
	var walls_size : Vector2i = Vector2i(floor_rect.size + 6 * Vector2i.ONE)
	var offsets : Array[Vector2i] = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(1, 1), Vector2i(1, -1), Vector2i(0, -1), Vector2i(0, 1), Vector2i(-1, -1), Vector2i(-1, 1)]
	for x : int in range(walls_size.x):
		for y : int in range(walls_size.y):
			if not floor.get_cell_tile_data(0, walls_corner + Vector2i(x, y)):
				var place : bool = false
				for offset : Vector2i in offsets:
					place = place or floor.get_cell_tile_data(0, walls_corner + Vector2i(x, y) + offset)
				if place:
					set_wall(walls_corner + Vector2i(x, y))

func put_connections_on_tilemap(rooms : Array[LevelUtilities.Room]) -> void:
	var new_connections : Array[LevelUtilities.Connection] = []
	
	for room : LevelUtilities.Room in rooms:
		for connection : LevelUtilities.Connection in room.connections:
			# Establish rooms visited while making this connection
			var last_room_visited : LevelUtilities.Room = room
			# Check if this connection has already been handled.
			if connection.connected:
				continue
			connection.connected = true
			# Choose whether or not to go horizontally
			var going_horizontally : bool = true if randf() > 0.5 else false
			var pos : Vector2i = connection.one.rect.get_center() 
			var end : Vector2i = connection.two.rect.get_center()
			# While we haven't conencted the rooms
			while (pos - end).length() != 0:
				# Draw the corridor on the tilemap
				for i : int in range(hallway_width):
					for j : int in range(hallway_width):
						var tile_pos : Vector2i = pos + Vector2i(i - hallway_width / 2, j - hallway_width / 2)
						if not (connection.one.rect.has_point(tile_pos) or connection.two.rect.has_point(tile_pos)):
							set_floor(tile_pos)
				# Determine if we are drawing a hallway in a room
				var in_room : LevelUtilities.Room = null
				for possible_visit : LevelUtilities.Room in rooms:
					if possible_visit.rect.has_point(pos):
						in_room = possible_visit
				if in_room:
					if not last_room_visited == in_room:
						new_connections.append(LevelUtilities.Connection.new(in_room, last_room_visited))
						new_connections.back().connected = true
						last_room_visited = in_room
				
				# Determine next position
				if going_horizontally:
					if end.x > pos.x:
						pos += Vector2i(1, 0)
					elif end.x < pos.x:
						pos -= Vector2i(1, 0)
					else:
						going_horizontally = false
				else:
					if end.y > pos.y:
						pos += Vector2i(0, 1)
					elif end.y < pos.y:
						pos -= Vector2i(0, 1)
					else:
						going_horizontally = true
		# Get rid of these connections as they will be replaced
		room.connections.clear()

	# Finally, reassign connections
	for connection : LevelUtilities.Connection in new_connections:
		connection.one.connections.append(connection)
		connection.two.connections.append(connection)
				
	
func move_player(entity : Entity, room : LevelUtilities.Room = null) -> void:
	if room:
		entity.global_position = floor.to_global(floor.map_to_local(room.rect.get_center()))
	else:
		entity.global_position = floor.to_global(floor.map_to_local(graph_data.longest_path.front().rect.get_center()))
func shrink_rooms(rooms : Array[LevelUtilities.Room], amount : int) -> void:
	for room : LevelUtilities.Room in rooms:
		room.rect.position += amount * Vector2i.ONE
		room.rect.size -= amount * Vector2i.ONE

func attempt_to_use_templates(rooms : Array[LevelUtilities.Room]) -> void:
	var first_filter : Callable = func(template : TileMap, room : LevelUtilities.Room) -> bool:
		if template.get_used_rect().size.x >= room.rect.size.x:
			return false
		if template.get_used_rect().size.y >= room.rect.size.y:
			return false
		return true
	var second_filter : Callable = func(template : TileMap, room : LevelUtilities.Room) -> bool:
		if template.get_used_rect().get_area() < 0.5 * room.rect.get_area():
			return false
		return true

	for room : LevelUtilities.Room in rooms:
		var temp_lambda : Callable = first_filter.bind(room)
		var temp_lambda_second : Callable = second_filter.bind(room)
		var possible_templates : Array = layouts.filter(temp_lambda)
		var preferred_templates : Array = possible_templates.filter(temp_lambda_second)
		var template : TileMap
		if not possible_templates:
			template = layouts.pick_random()
			push_error("Failed to use templates within constraits.")
		elif preferred_templates:
			template = preferred_templates.pick_random()
		else:
			template = possible_templates.pick_random()
		var offset : Vector2i = room.rect.get_center() - template.get_used_rect().get_center()
		var template_rect : Rect2i = template.get_used_rect()
		room.rect = Rect2i(template_rect.position + offset, template_rect.size)
		for i : int in range(template_rect.position.y, template_rect.position.y + template_rect.size.y):
			for j : int in range(template_rect.position.x, template_rect.position.x + template_rect.size.x):
				if template.get_cell_tile_data(0, Vector2i(j, i)):
					assert(room.rect.has_point(Vector2i(j, i) + offset))
					set_floor(Vector2i(j, i) + offset)
		room.marker_global_positions.append_array(template.get_children().map(func x(a): return a.global_position + Vector2(offset) * 16))
		room.marker_global_positions.shuffle()
	
func draw_connections() -> void:
	for room : LevelUtilities.Room in current_rooms:
		for connection : LevelUtilities.Connection in room.connections:
			var line : Line2D = Line2D.new()
			line.z_index = 100
			var points : PackedVector2Array = PackedVector2Array()
			points.append(floor.to_global(floor.map_to_local(connection.one.rect.get_center())))
			points.append(floor.to_global(floor.map_to_local(connection.two.rect.get_center())))
			line.points = points
			line.antialiased = true
			line.width = 5
			line.add_to_group("connection")
			add_child(line)

func generate_bsp() -> void:
	for child : Node in get_tree().get_nodes_in_group("npcs"):
		child.queue_free()
	get_tree().call_group("connection", "queue_free")
	var size : Vector2i = Vector2i(lerp(level_min_size.x, level_max_size.x, randf()), lerp(level_min_size.y, level_max_size.y, randf()))
	var rect : Rect2i = Rect2i(Vector2i.ZERO - size / 2, size)
	floor.clear()
	walls.clear()
	var part : LevelUtilities.Partition = LevelUtilities.Partition.new(rect, room_min_size, room_max_size)
	var rooms : Array[LevelUtilities.Room] = part.make_rooms()
	shrink_rooms(rooms, 2)
	attempt_to_use_templates(rooms)
	current_rooms = rooms
	# put_rooms_on_tilemap(rooms)
	put_connections_on_tilemap(rooms)
	fill_with_walls()
	graph_data = LevelUtilities.GraphData.new(rooms)
	var longest_path : Array[LevelUtilities.Room] = graph_data.longest_path
	path_length = longest_path.size()
	var player : Entity = get_tree().get_first_node_in_group("players")
	if player:
		move_player(player, longest_path.front())
	for i : int in range(5):
		graph_data.assign_reward_room()
	graph_data.populate_rooms()
	# draw_connections()
	FloorHandler.init_for_room()
	regenerated.emit()
