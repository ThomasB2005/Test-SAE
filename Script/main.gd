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
	
	
	
@onready var enemy_scene = preload("res://Scenes/Enemy/Enemy.tscn")
