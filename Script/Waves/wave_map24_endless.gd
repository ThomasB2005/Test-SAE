extends Node
class_name WaveMap24Endless

# Map 24 Endless Mode - Infinite waves with scaling difficulty
# Progression: enemy8-9 + bat

static func get_waves() -> Array[Wave]:
	var waves: Array[Wave] = []
	
	waves.append(Wave.new(1, [{"enemy_type":"enemy8","count":24},{"enemy_type":"enemy9","count":11}], 1.0, 4.0))
	waves.append(Wave.new(2, [{"enemy_type":"enemy8","count":26},{"enemy_type":"enemy9","count":12}], 0.9, 4.0))
	waves.append(Wave.new(3, [{"enemy_type":"enemy9","count":28},{"enemy_type":"bat","count":11}], 0.8, 4.0))
	waves.append(Wave.new(4, [{"enemy_type":"enemy9","count":30},{"enemy_type":"bat","count":13}], 0.7, 4.0))
	waves.append(Wave.new(5, [{"enemy_type":"enemy9","count":32},{"enemy_type":"bat","count":15}], 0.6, 4.0))
	
	return waves
