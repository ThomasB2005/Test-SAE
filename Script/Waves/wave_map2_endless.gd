extends Node
class_name WaveMap2Endless

# Map 2 Endless Mode - Infinite waves with scaling difficulty
# Progression: enemy1-4 + bat

static func get_waves() -> Array[Wave]:
	var waves: Array[Wave] = []
	
	# Cycle of 5 waves that repeat with increasing difficulty
	waves.append(Wave.new(1, [{"enemy_type":"enemy1","count":10},{"enemy_type":"enemy2","count":4}], 1.8, 4.0))
	waves.append(Wave.new(2, [{"enemy_type":"enemy2","count":12},{"enemy_type":"enemy3","count":5}], 1.7, 4.0))
	waves.append(Wave.new(3, [{"enemy_type":"enemy3","count":14},{"enemy_type":"bat","count":4}], 1.6, 4.0))
	waves.append(Wave.new(4, [{"enemy_type":"enemy3","count":16},{"enemy_type":"enemy4","count":6}], 1.5, 4.0))
	waves.append(Wave.new(5, [{"enemy_type":"enemy4","count":18},{"enemy_type":"bat","count":6}], 1.4, 4.0))
	
	return waves
