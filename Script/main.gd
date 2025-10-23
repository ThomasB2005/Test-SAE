extends Node

@export var path_tile:PackedScene
@export var tile_start:PackedScene
@export var tile_end:PackedScene
@export var tile_empty:PackedScene
@export var tower_tile:PackedScene

@export var map_length:int = 16
@export var map_height:int = 9

@export var min_path_size:int
@export var max_path_size:int

var _pg:PathGenerator

func _ready() -> void:
	_pg = PathGenerator.new(map_length, map_height)
	_display_path()
	_complete_grid()
	_display_tower_tile()

func _complete_grid():
	for x in range(map_length):
		for y in range(map_height):
			if not _pg.get_path().has(Vector2i(x,y)) and not _pg.get_tower_tile().has(Vector2i(x,y)):
				var tile:Node3D = tile_empty.instantiate()
				add_child(tile)
				tile.global_position = Vector3(x, 0, y)
				

func _display_tower_tile():
	var _tower_tiles:Array[Vector2i] = _pg.generate_tower_tile()
	print("Tower tiles generated: ", _tower_tiles.size())
	
	for element in _tower_tiles:
		var tile:Node3D = tower_tile.instantiate()
		add_child(tile)
		tile.global_position = Vector3(element.x, 0, element.y)

func _display_path():
	var _path:Array[Vector2i] = _pg.generate_path()
	print(_path)
	print(_path[0])
	
	while _pg.get_path().size() < min_path_size or _pg.get_path().size() > max_path_size:
		_pg.generate_path()
	
	for element in _path:
		var tile_score:int = _pg.get_tile_score(element)
		#print(tile_score)
		var tile:Node3D = path_tile.instantiate()
		
		if tile_score == 2:
			tile = tile_start.instantiate()
		elif tile_score == 8:
			tile = tile_end.instantiate()
		
		add_child(tile)
		tile.global_position = Vector3(element.x , 0, element.y)
	
@onready var enemy_scene = preload("res://Scenes/Enemy/Enemy.tscn")

func _spawn_enemy():
	var enemy_instance = enemy_scene.instantiate()
	add_child(enemy_instance)
	print('Enemy spawned')
	
	enemy_instance.path = _pg.get_path()
