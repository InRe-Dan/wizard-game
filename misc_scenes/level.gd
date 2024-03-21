class_name Level extends Node2D

@export_category("Room settings")
@export var room_size : Vector2i = Vector2i(15, 9)
@export var door_width : int = 3
@export var wall_padding : int = 20
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

class Room extends RefCounted:
	func _init(rect : Rect2i) -> void:
		self.rect = rect
	
	var rect : Rect2i
	var north : Room
	var east : Room
	var south : Room
	var west : Room
	
class Partition extends RefCounted:
	enum SplitDir {Horizontal, Vertical}
	func _init(rect : Rect2i, level : int = 1) -> void:
		self.rect = rect
		self.level = level
		var string : String = ""
		for i : int in range(level - 1):
			string += "    "
		string += str(rect)
		print(string)
		
		if level >= 4:
			return

		split_dir = SplitDir.values().pick_random()
		if split_dir == SplitDir.Horizontal:
			var one_height : int = rect.size.y / 2 + randi_range(-3, 3)
			var y : int = rect.position.y + one_height
			var one_pos : Vector2i = Vector2i(rect.position.x, rect.position.y)
			var one_size : Vector2i = Vector2i(rect.size.x, one_height)
			var two_pos : Vector2i = Vector2i(rect.position.x, y)
			var two_size : Vector2i = Vector2i(rect.size.x, rect.size.y - one_height)
			one = Partition.new(Rect2i(one_pos, one_size), level + 1)
			two = Partition.new(Rect2i(two_pos, two_size), level + 1)
		elif split_dir == SplitDir.Vertical:
			var one_width : int = rect.size.x / 2 + randi_range(-3, 3)
			var x : int = rect.position.x + one_width
			var one_pos : Vector2i = Vector2i(rect.position.x, rect.position.y)
			var one_size : Vector2i = Vector2i(one_width, (rect.size.y))
			var two_pos : Vector2i = Vector2i(x, rect.position.y)
			var two_size : Vector2i = Vector2i(rect.size.x - one_width, rect.size.y)
			one = Partition.new(Rect2i(one_pos, one_size), level + 1)
			two = Partition.new(Rect2i(two_pos, two_size), level + 1)
		assert(not one.rect.intersects(two.rect))
		assert(one.rect.get_area() + two.rect.get_area() == rect.get_area())
				
	func make_rooms(array : Array[Room] = []) -> Array[Room]:
		if not one:
			room = Room.new(Rect2i(rect.position + Vector2i.ONE, rect.size - Vector2i.ONE))
			array.append(room)
		else:
			one.make_rooms(array)
			two.make_rooms(array)
			if split_dir == SplitDir.Vertical:
				one.room.west = two.room
				two.room.east = one.room
			else:
				one.room.south = two.room
				two.room.north = one.room
			room = [one.room, two.room].pick_random()
		return array

	var rect : Rect2i
	var split_dir : SplitDir
	var one : Partition = null
	var two : Partition = null
	var room : Room = null
	var level : int

func _ready() -> void:
	generate_bsp(Rect2i(-20, -20, 40, 40))

func populate_room(room : Room) -> void:
	var enemies : int = randi_range(min_enemies_per_room, max_enemies_per_room)
	var items : int = randi_range(min_items_per_room, max_items_per_room)
	var positions : Array[Vector2i] = []
	while positions.size() < enemies + items + 1:
		var x : int = randi_range(room.rect.position.x + 1, room.rect.position.x + room.rect.size.x - 1)
		var y : int = randi_range(room.rect.position.y + 1, room.rect.position.y + room.rect.size.y - 1)
		positions.append(Vector2i(x, y))
	while enemies > 0:
		var pos : Vector2i = positions.pop_front()
		var enemy : Entity = (enemy_list.pick_random() as EntityResource).make_entity()
		enemy.global_position = floor.to_global(floor.map_to_local(pos))
		add_child(enemy)
		enemies -= 1
	while items > 0:
		var pos : Vector2i = positions.pop_front()
		var pickup : ItemPickupEntity = (item_list.pick_random() as ItemResource).make_item_pickup()
		pickup.global_position = floor.to_global(floor.map_to_local(pos))
		add_child(pickup)
		items -= 1
	var pos : Vector2i = positions.pop_front()
	var pickup : EffectPickupEntity = (passive_list.pick_random() as PassiveResource).make_item_pickup()
	pickup.global_position = floor.to_global(floor.map_to_local(pos))
	add_child(pickup)

func set_floor(v : Vector2i) -> void:
	floor.set_cell(0, v, 58, Vector2i(range(0, 8).pick_random(), 0))
func set_wall(v : Vector2i) -> void:
	walls.set_cell(0, v, 0, Vector2i(range(4, 8).pick_random(), 4))

func put_rooms_on_tilemap(rooms : Array[Room]) -> void:
	for room : Room in rooms:
		for i : int in range(room.rect.size.y):
			for j : int in range(room.rect.size.x):
				set_floor(room.rect.position + Vector2i(j, i))
		populate_room(room)
				
		for i : int in range(door_width):
			if room.north:
				set_floor(Vector2i(room.rect.position.x + room.rect.size.x / 2 - door_width / 2 + i, (room.rect.position.y - 1)))
			if room.east:
				set_floor(Vector2i(room.rect.position.x - 1, room.rect.position.y + room.rect.size.y / 2 - door_width / 2 + i))
			if room.south:
				set_floor(Vector2i(room.rect.position.x + room.rect.size.x / 2 - door_width / 2 + i, room.rect.position.y + room.rect.size.y  + 1))
			if room.west:
				set_floor(Vector2i(room.rect.position.x + room.rect.size.x, room.rect.position.y + room.rect.size.y / 2 - door_width / 2 + i))
	var floor_rect : Rect2i = floor.get_used_rect()
	var walls_corner : Vector2i = Vector2i(floor_rect.position - wall_padding * Vector2i.ONE)
	var walls_size : Vector2i = Vector2i(floor_rect.size + wall_padding * 2 * Vector2i.ONE)
	var offsets : Array[Vector2i] = [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(1, 1), Vector2i(1, -1), Vector2i(0, -1), Vector2i(0, 1), Vector2i(-1, -1), Vector2i(-1, 1)]
	for x : int in range(walls_size.x):
		for y : int in range(walls_size.y):
			if not floor.get_cell_tile_data(0, walls_corner + Vector2i(x, y)):
				var place : bool = false
				for offset : Vector2i in offsets:
					place = place or floor.get_cell_tile_data(0, walls_corner + Vector2i(x, y) + offset)
				if place:
					set_wall(walls_corner + Vector2i(x, y))
	FloorHandler.init_for_room()

func generate_tiled(room_count : int) -> void:
	floor.clear()
	walls.clear()
	var rooms : Array[Room]
	var start_corner : Vector2i = - (room_size - Vector2i.ONE) / 2
	rooms.append(Room.new(Rect2i(start_corner, room_size)))
	var rooms_made : int = 1
	
	while rooms_made < room_count:
		var random_room : Room = rooms.pick_random()
		var random_direction : int = randi() % 4
		match random_direction:
			0:
				if not random_room.north:
					var new_pos : Vector2i = random_room.rect.position - Vector2i(0, (room_size.y + 1))
					var new_room : Room = Room.new(Rect2i(new_pos, room_size))
					random_room.north = new_room
					new_room.south = random_room
					rooms.append(new_room)
					rooms_made += 1
			1:
				if not random_room.east:
					var new_pos : Vector2i = random_room.rect.position - Vector2i( (room_size.x + 1), 0)
					var new_room : Room = Room.new(Rect2i(new_pos, room_size))
					random_room.east = new_room
					new_room.west = random_room
					rooms.append(new_room)
					rooms_made += 1
			2:
				if not random_room.south:
					var new_pos : Vector2i = random_room.rect.position - Vector2i(0, - (room_size.y + 1))
					var new_room : Room = Room.new(Rect2i(new_pos, room_size))
					random_room.south = new_room
					new_room.north = random_room
					rooms.append(new_room)
					rooms_made += 1
			3:
				if not random_room.west:
					var new_pos : Vector2i = random_room.rect.position - Vector2i(-(room_size.x + 1), 0)
					var new_room : Room = Room.new(Rect2i(new_pos, room_size))
					random_room.west = new_room
					new_room.east = random_room
					rooms.append(new_room)
					rooms_made += 1
	
	put_rooms_on_tilemap(rooms)
	
func generate_bsp(rect : Rect2i) -> void:
	floor.clear()
	walls.clear()
	var part : Partition = Partition.new(rect)
	var rooms : Array[Room] = part.make_rooms()
	put_rooms_on_tilemap(rooms)
