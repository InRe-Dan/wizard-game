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

var current_rooms : Array[Room]
var layouts : Array[RoomLayout]

class Connection extends RefCounted:
	func _init(one : Room, two : Room) -> void:
		self.one = one
		self.two = two
	var one : Room
	var two : Room
	var connected : bool = false

class Room extends RefCounted:
	func _init(rect : Rect2i) -> void:
		self.rect = rect
	
	var rect : Rect2i
	var connections : Array[Connection]
	
class Partition extends RefCounted:
	enum SplitDir {Horizontal, Vertical}
	func _init(rect : Rect2i, max : Vector2i, min : Vector2i, level : int = 0) -> void:
		self.rect = rect
		self.level = level
	
		# Determine if there is enough room to split in each direction
		var can_split_h : bool = false
		var can_split_v : bool = false
		if rect.size.x > max.x:
			can_split_v = true
		if rect.size.y > max.y:
			can_split_h = true

		var split_dir : SplitDir
		if can_split_h and can_split_v:
			split_dir = SplitDir.values().pick_random()
		elif can_split_h:
			split_dir = SplitDir.Horizontal
		elif can_split_v:
			split_dir = SplitDir.Vertical
		else:
			return
		if split_dir == SplitDir.Horizontal:
			var one_height : int = rect.size.y / 2 + randi_range(-3, 3)
			var y : int = rect.position.y + one_height
			var one_pos : Vector2i = Vector2i(rect.position.x, rect.position.y)
			var one_size : Vector2i = Vector2i(rect.size.x, one_height)
			var two_pos : Vector2i = Vector2i(rect.position.x, y)
			var two_size : Vector2i = Vector2i(rect.size.x, rect.size.y - one_height)
			one = Partition.new(Rect2i(one_pos, one_size), min, max, level + 1)
			two = Partition.new(Rect2i(two_pos, two_size), min, max, level + 1)
		elif split_dir == SplitDir.Vertical:
			var one_width : int = rect.size.x / 2 + randi_range(-3, 3)
			var x : int = rect.position.x + one_width
			var one_pos : Vector2i = Vector2i(rect.position.x, rect.position.y)
			var one_size : Vector2i = Vector2i(one_width, (rect.size.y))
			var two_pos : Vector2i = Vector2i(x, rect.position.y)
			var two_size : Vector2i = Vector2i(rect.size.x - one_width, rect.size.y)
			one = Partition.new(Rect2i(one_pos, one_size), min, max, level + 1)
			two = Partition.new(Rect2i(two_pos, two_size), min, max, level + 1)
		assert(not one.rect.intersects(two.rect))
		assert(one.rect.get_area() + two.rect.get_area() == rect.get_area())
				
	func make_rooms(array : Array[Room] = []) -> Array[Room]:
		if not one:
			room = Room.new(Rect2i(rect.position + Vector2i.ONE, rect.size - Vector2i.ONE))
			array.append(room)
		else:
			one.make_rooms(array)
			two.make_rooms(array)
			var conn : Connection = Connection.new(one.room, two.room)
			one.room.connections.append(conn)
			two.room.connections.append(conn)
			room = [one.room, two.room].pick_random()
		return array

	var rect : Rect2i
	var split_dir : SplitDir
	var one : Partition = null
	var two : Partition = null
	var room : Room = null
	var level : int

func _ready() -> void:
	var files : PackedStringArray = DirAccess.get_files_at("res://room_blueprints/")
	for file : String in files:
		layouts.append(load("res://room_blueprints/" + file).instantiate())
	generate_bsp()

func set_floor(v : Vector2i) -> void:
	if not floor.get_cell_tile_data(0, v):
		floor.set_cell(0, v, 58, Vector2i(range(0, 8).pick_random(), 0))
func set_wall(v : Vector2i) -> void:
	if not walls.get_cell_tile_data(0, v):
		walls.set_cell(0, v, 0, Vector2i(range(4, 8).pick_random(), 4))

func put_rooms_on_tilemap(rooms : Array[Room]) -> void:
	for room : Room in rooms:
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
	
func put_connections_on_tilemap(rooms : Array[Room]) -> void:
	for room : Room in rooms:
		for connection : Connection in room.connections:
			if connection.connected:
				continue
			connection.connected = true
			var going_horizontally : bool = true if randf() > 0.5 else false
			var pos : Vector2i = connection.one.rect.get_center() 
			var end : Vector2i = connection.two.rect.get_center()
			while (pos - end).length() != 0:
				for i : int in range(hallway_width):
					for j : int in range(hallway_width):
						set_floor(pos + Vector2i(i - hallway_width / 2, j - hallway_width / 2))
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
			
				
	
func move_player(entity : Entity) -> void:
	entity.global_position = floor.to_global(floor.map_to_local(current_rooms.front().rect.get_center()))

func shrink_rooms(rooms : Array[Room], amount : int) -> void:
	for room : Room in rooms:
		room.rect.position += amount * Vector2i.ONE
		room.rect.size -= amount * Vector2i.ONE

func attempt_to_use_templates(rooms : Array[Room]) -> void:
	var lambda : Callable = func(template : RoomLayout, room : Room) -> bool:
		if template.get_used_rect().size.x > room.rect.size.x:
			return false
		if template.get_used_rect().size.y > room.rect.size.y:
			return false
		return true

	var sort_function : Callable = func(a : RoomLayout, b : RoomLayout) -> bool:
		if a.get_used_rect().get_area() > b.get_used_rect().get_area():
			return true
		return false

	for room : Room in rooms:
		lambda.bind(room)
		var possible_templates : Array = layouts.filter(lambda)
		lambda.unbind(1)
		possible_templates.sort_custom(sort_function)
		var largest_template : RoomLayout = possible_templates.front()
		if not largest_template:
			continue
		var offset : Vector2i = room.rect.get_center() - largest_template.get_used_rect().get_center()
		for i : int in range(largest_template.get_used_rect().size.y):
			for j : int in range(largest_template.get_used_rect().size.x):
				if largest_template.get_cell_tile_data(0, Vector2i(j, i)):
					set_floor(Vector2i(j, i) - offset)

func generate_bsp() -> void:
	var size : Vector2i = level_min_size + Vector2i((level_max_size - level_min_size) * (randf()))
	var rect : Rect2i = Rect2i(Vector2i.ZERO - size / 2, size)
	floor.clear()
	walls.clear()
	var part : Partition = Partition.new(rect, room_min_size, room_max_size)
	var rooms : Array[Room] = part.make_rooms()
	shrink_rooms(rooms, 2)
	attempt_to_use_templates(rooms)
	current_rooms = rooms
	# put_rooms_on_tilemap(rooms)
	put_connections_on_tilemap(rooms)
	fill_with_walls()
	var player : Entity = get_tree().get_first_node_in_group("players")
	if player:
		move_player(player)
	FloorHandler.init_for_room()
