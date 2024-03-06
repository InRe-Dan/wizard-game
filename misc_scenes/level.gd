extends Node2D

@export var room_size : Vector2i = Vector2i(15, 9)
@export var door_width : int = 3
@export var wall_padding : int = 20

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

func _ready() -> void:
	generate(20)
	pass

func set_floor(v : Vector2i) -> void:
	floor.set_cell(0, v, 58, Vector2i(range(0, 8).pick_random(), 0))
func set_wall(v : Vector2i) -> void:
	walls.set_cell(0, v, 0, Vector2i(range(4, 8).pick_random(), 4))

func generate(room_count : int) -> void:
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
	
	for room : Room in rooms:
		for i : int in range(room.rect.size.y):
			for j : int in range(room.rect.size.x):
				set_floor(room.rect.position + Vector2i(j, i))
				
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
	for x : int in range(walls_size.x):
		for y : int in range(walls_size.y):
			if not floor.get_cell_tile_data(0, walls_corner + Vector2i(x, y)):
				set_wall(walls_corner + Vector2i(x, y))
	
	FloorHandler.init_for_room()
