extends Node
class_name WaveMap8Endless

# Map 8 Endless Mode - Infinite waves with scaling difficulty
# Progression: enemy4-8 + bat

static func get_waves() -> Array[Wave]:
	var waves: Array[Wave] = []
	
	waves.append(Wave.new(1, [{"enemy_type":"enemy4","count":16},{"enemy_type":"enemy5","count":7}], 1.4, 4.0))
	waves.append(Wave.new(2, [{"enemy_type":"enemy5","count":18},{"enemy_type":"enemy6","count":8}], 1.3, 4.0))
	waves.append(Wave.new(3, [{"enemy_type":"enemy6","count":20},{"enemy_type":"bat","count":7}], 1.2, 4.0))
	waves.append(Wave.new(4, [{"enemy_type":"enemy7","count":22},{"enemy_type":"enemy8","count":9}], 1.1, 4.0))
	waves.append(Wave.new(5, [{"enemy_type":"enemy8","count":24},{"enemy_type":"bat","count":9}], 1.0, 4.0))
	
	return waves
