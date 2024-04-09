class_name LevelUtilities extends Object

func _init() -> void:
	push_error("Do not instantiate.")

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
	var marker_global_positions : Array[Vector2]
	var id : int = -1
	var is_key_room : bool = false
	var distance_from_key_rooms : int = 100
	
class Partition extends RefCounted:
	enum SplitDir {Horizontal, Vertical}
	enum SplitHalf {First, Second}
	func _init(rect : Rect2i, min : Vector2i, max : Vector2i, level : int = 0) -> void:
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
			var one_height : int = rect.size.y / 2 + randi_range(-5, 5)
			var y : int = rect.position.y + one_height
			var one_pos : Vector2i = Vector2i(rect.position.x, rect.position.y)
			var one_size : Vector2i = Vector2i(rect.size.x, y - rect.position.y)
			var two_pos : Vector2i = Vector2i(rect.position.x, y)
			var two_size : Vector2i = Vector2i(rect.size.x, rect.size.y - (y - rect.position.y))
			one = Partition.new(Rect2i(one_pos, one_size), min, max, level + 1)
			two = Partition.new(Rect2i(two_pos, two_size), min, max, level + 1)
		elif split_dir == SplitDir.Vertical:
			var one_width : int = rect.size.x / 2 + randi_range(-5, 5)
			var x : int = rect.position.x + one_width
			var one_pos : Vector2i = Vector2i(rect.position.x, rect.position.y)
			var one_size : Vector2i = Vector2i(x - rect.position.x, (rect.size.y))
			var two_pos : Vector2i = Vector2i(x, rect.position.y)
			var two_size : Vector2i = Vector2i(rect.size.x - (x - rect.position.x), rect.size.y)
			one = Partition.new(Rect2i(one_pos, one_size), min, max, level + 1)
			two = Partition.new(Rect2i(two_pos, two_size),  min, max, level + 1)
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
	
class GraphData extends RefCounted:
	var dist : Array[Array]
	var prev : Array[Array]
	var rooms : Array[Room]
	var longest_path : Array[Room]
	var reward_rooms : Array[Room]
	
	func _init(rooms : Array[Room]) -> void:
		dist = []
		prev = []
		for i : int in range(rooms.size()):
			dist.append([])
			prev.append([])
			for j : int in range(rooms.size()):
				dist[i].append(99)
				prev[i].append(null)
		floyd_warshall(rooms)
		make_longest_path()
		recompute_key_distances()

	func floyd_warshall(rooms : Array[Room]) -> void:
		# preprocessing for edges and giving rooms IDs
		var edges : Array[Connection] = []
		var id : int = 0
		self.rooms = rooms
		for room : Room in rooms:
			room.id = id
			id += 1
			edges.append_array(room.connections)
		for i : int in range(edges.size()):
			print(edges[i].one.id, " ", edges[i].two.id)
			var u : Room = edges[i].one
			var v : Room = edges[i].two
			dist[u.id][v.id] = 1
			dist[v.id][u.id] = 1
			prev[u.id][v.id] = u
			prev[v.id][u.id] = v
		for i : int in range(rooms.size()):
			dist[rooms[i].id][rooms[i].id] = 0
			prev[rooms[i].id][rooms[i].id] = rooms[i]
		
		var room_count : int = rooms.size()
		for k : int in range(room_count):
			for i : int in range(room_count):
				for j : int in range(room_count):
					if dist[i][j] > dist[i][k] + dist[k][j]:
						dist[i][j] = dist[i][k] + dist[k][j]
						prev[i][j] = prev[k][j]

	func path(start : Room, end : Room) -> Array[Room]:
		var array : Array[Room] = []
		if prev[start.id][end.id] == null:
			return array
		array.append(end)
		while end != start:
			end = prev[start.id][end.id]
			array.push_front(end)
		return array
	
	func recompute_key_distances() -> void:
		for room in rooms:
			for secondary_room in rooms:
				if secondary_room.is_key_room:
					room.distance_from_key_rooms = min(path(room, secondary_room).size(), room.distance_from_key_rooms)

	func assign_reward_room() -> void:
		var candidate : Room = null
		var best_distance = 0
		for room in rooms:
			if room.distance_from_key_rooms > best_distance:
				candidate = room
				best_distance = room.distance_from_key_rooms
		if candidate:
			print(candidate)
			reward_rooms.append(candidate)
			candidate.is_key_room = true
			recompute_key_distances()
	
	func make_longest_path() -> void:
		var coordinates : Vector2i = get_longest_path_coordinates()
		longest_path = path(rooms[coordinates.x], rooms[coordinates.y])
		for room : Room in longest_path:
			room.is_key_room = true
		recompute_key_distances()

	func get_longest_path_coordinates() -> Vector2i:
		var largest : Vector2i = - Vector2.ONE
		var largest_value : int = 0
		for i : int in range(dist.size()):
			for j : int in range(dist.size()):
				var value : int = dist[i][j]
				if value > largest_value:
					largest_value = value
					largest = Vector2i(j, i)
		assert(largest != - Vector2i.ZERO)
		return largest
	
	func print_dist() -> void:
		for i : int in range(dist.size()):
			var string : String = ""
			for j : int in range(dist.size()):
				string += str(dist[i][j]) + " "
			print(string)
