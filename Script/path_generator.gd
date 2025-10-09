extends Object
class_name PathGenerator

var _grid_length:int = 16
var _grid_height:int = 8

var _path: Array[Vector2i]
var _tower_tile: Array[Vector2i]

func _init(length:int, height:int):
	_grid_length = length
	_grid_height = height
	
func generate_path():
	_path.clear()
	
	var x = 0
	var y = int(_grid_height/2)
	
	while x < _grid_length:
		if not _path.has(Vector2i(x,y)):
			_path.append(Vector2i(x,y))
			
		var choice:int = randi_range(0,4)
		
		if choice == 0 or x % 2 == 0 or x == _grid_length-1:
			x += 1
		elif choice == 1 and y < _grid_height-2 and not _path.has(Vector2i(x,y+1)):
			y += 1
		elif choice == 2 and y > 1 and not _path.has(Vector2i(x,y-1)):
			y -= 1
		#elif choice == 3 and y < _grid_height-2 and not _path.has((Vector2i(x-1,y))):
			#x -= 1
		#elif choice == 4 and y > 0:
			#y -= 1
			
	return _path
	
func generate_tower_tile():
	_tower_tile.clear()

	var max_distance = 2
	
	for path_tile in _path:
		for dx in range(-max_distance, max_distance + 1):
			for dy in range(-max_distance, max_distance + 1):
				var tower_pos = path_tile + Vector2i(dx, dy)
				
				if _path.has(tower_pos):
					continue
				if tower_pos.x < 0 or tower_pos.x >= _grid_length:
					continue
				if tower_pos.y < 0 or tower_pos.y >= _grid_height:
					continue
				
				if not _tower_tile.has(tower_pos):
					_tower_tile.append(tower_pos)
	
	return _tower_tile
	
func get_tile_score(tile:Vector2i) -> int:
	var score:int = 0
	var x = tile.x
	var y = tile.y
	
	score += 1 if _path.has(Vector2i(x,y-1)) else 0
	score += 2 if _path.has(Vector2i(x+1,y)) else 0
	score += 4 if _path.has(Vector2i(x,y+1)) else 0
	score += 8 if _path.has(Vector2i(x-1,y)) else 0
	
	return score

func get_path() -> Array[Vector2i]:
	return _path
	
func get_tower_tile() -> Array[Vector2i]:
	return _tower_tile
	
