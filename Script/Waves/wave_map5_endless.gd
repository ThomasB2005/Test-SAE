extends Node
class_name WaveMap5Endless

# Map 5 Endless Mode - Infinite waves with scaling difficulty
# Progression: enemy3-6 + bat

static func get_waves() -> Array[Wave]:
	var waves: Array[Wave] = []
	
	waves.append(Wave.new(1, [{"enemy_type":"enemy3","count":14},{"enemy_type":"enemy4","count":6}], 1.6, 4.0))
	waves.append(Wave.new(2, [{"enemy_type":"enemy4","count":16},{"enemy_type":"enemy5","count":7}], 1.5, 4.0))
	waves.append(Wave.new(3, [{"enemy_type":"enemy5","count":18},{"enemy_type":"bat","count":6}], 1.4, 4.0))
	waves.append(Wave.new(4, [{"enemy_type":"enemy5","count":20},{"enemy_type":"enemy6","count":8}], 1.3, 4.0))
	waves.append(Wave.new(5, [{"enemy_type":"enemy6","count":22},{"enemy_type":"bat","count":8}], 1.2, 4.0))
	
	return waves
