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
	
class Partition extends RefCounted:
	enum SplitDir {Horizontal, Vertical}
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