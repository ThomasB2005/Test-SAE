extends Camera3D

@export var map_length:int = 16
@export var map_height:int = 8

func _ready() -> void:
	global_position = Vector3(map_length/2,10,14)
