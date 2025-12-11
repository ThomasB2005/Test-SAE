extends Node
class_name WaveMap1

# Map 1 Wave Configuration - 4 Waves (Tutorial/Easy)

static func get_waves() -> Array[Wave]:
	var waves: Array[Wave] = []
	
	waves.append(Wave.new(1, [{"enemy_type":"enemy1","count":5}], 2.5, 5.0))
	waves.append(Wave.new(2, [{"enemy_type":"enemy1","count":8},{"enemy_type":"enemy2","count":2}], 2.0, 5.0))
	waves.append(Wave.new(3, [{"enemy_type":"enemy2","count":8},{"enemy_type":"enemy3","count":3}], 1.8, 5.0))
	waves.append(Wave.new(4, [{"enemy_type":"enemy3","count":10},{"enemy_type":"bat","count":2}], 1.5, 0.0))
	
	return waves
