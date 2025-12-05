extends Node
class_name WaveMap21Endless

# Map 21 Endless Mode - Infinite waves with scaling difficulty
# Progression: enemy6-9 + bat

static func get_waves() -> Array[Wave]:
	var waves: Array[Wave] = []
	
	waves.append(Wave.new(1, [{"enemy_type":"enemy6","count":20},{"enemy_type":"enemy7","count":10}], 1.2, 4.0))
	waves.append(Wave.new(2, [{"enemy_type":"enemy7","count":22},{"enemy_type":"enemy8","count":11}], 1.1, 4.0))
	waves.append(Wave.new(3, [{"enemy_type":"enemy8","count":24},{"enemy_type":"bat","count":10}], 1.0, 4.0))
	waves.append(Wave.new(4, [{"enemy_type":"enemy8","count":26},{"enemy_type":"enemy9","count":12}], 0.9, 4.0))
	waves.append(Wave.new(5, [{"enemy_type":"enemy9","count":28},{"enemy_type":"bat","count":12}], 0.8, 4.0))
	
	return waves
