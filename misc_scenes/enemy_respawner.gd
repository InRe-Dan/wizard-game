extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.level.regenerated.connect(level_regen)

func level_regen() -> void:
	for room in Global.level.current_rooms:
		room.cleared.connect(room_clear)

func spawn_rewards(room : LevelUtilities.Room) -> void:
	await get_tree().create_timer(0.5).timeout
	var spawns : int = room.marker_global_positions.size()
	var positions : Array[Vector2] = room.marker_global_positions.duplicate()
	positions.shuffle()
	var chest_entity : EntityResource = load("res://resources/entities/chest.tres")
	var to_spawn : int = min(randi_range(1, 3), spawns)
	for i in range(to_spawn):
		var spawner : EntitySpawner = chest_entity.make_spawner(0.5 + i * 0.1)
		Global.level.add_child(spawner)
		spawner.global_position = positions.pop_back()

func room_clear(room : LevelUtilities.Room) -> void:
	if room.wave >= room.wave_goal:
		spawn_rewards(room)
		return
	await get_tree().create_timer(0.5).timeout
	var spawns : int = room.marker_global_positions.size()
	var positions : Array[Vector2] = room.marker_global_positions.duplicate()
	positions.shuffle()
	var to_spawn : int = min(randi_range(min(spawns, 3), spawns + 1), spawns)
	for i in range(to_spawn):
		var spawner : EntitySpawner = Global.level.enemy_list.pick_random().make_spawner(0.5 + i * 0.1)
		room.enemies += 1
		spawner.room = room
		Global.level.add_child(spawner)
		spawner.global_position = positions.pop_back()
