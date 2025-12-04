extends Node

@export var path_tile:PackedScene
@export var tile_start:PackedScene
@export var tile_spawn:PackedScene
@export var tile_end:PackedScene
@export var tile_base:PackedScene
@export var tile_empty:PackedScene
@export var tower_tile:PackedScene

@export var path:Path3D

@export var map_length:int = 16
@export var map_height:int = 9

@export var min_path_size:int
@export var max_path_size:int

@onready var menu_scene = preload("res://Scenes/Menu/menu.tscn")

var _pg:PathGenerator

func _ready() -> void:
	get_tree().change_scene_to_packed(menu_scene)
	
	

	while _pg.get_path().size() < min_path_size or _pg.get_path().size() > max_path_size:
		_pg.generate_path()
	
	for element in _path:
		var tile_score:int = _pg.get_tile_score(element)
		#print(tile_score)
		var tile:Node3D = path_tile.instantiate()
		path.curve.add_point(Vector3(element.x, 0, element.y))
		
		if tile_score == 2:
			tile = tile_start.instantiate()
		elif tile_score == 8:
			tile = tile_end.instantiate()
		
		add_child(tile)
		tile.global_position = Vector3(element.x , 0, element.y)

	
@onready var enemy_scene = preload("res://Scenes/Enemy/Enemy.tscn")
