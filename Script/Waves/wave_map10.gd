extends Node
class_name WaveMap10

# Map 10 - 10 Waves, Boss on final wave (uses boss path)
static func get_waves() -> Array[Wave]:
	var waves: Array[Wave] = []

	waves.append(Wave.new(1, [{"enemy_type":"enemy4","count":14},], 1.8, 5.0))
	waves.append(Wave.new(2, [{"enemy_type":"enemy5","count":16},{"enemy_type":"enemy6","count":5}], 1.6, 5.0))
	waves.append(Wave.new(3, [{"enemy_type":"enemy6","count":18},{"enemy_type":"enemy7","count":6}], 1.5, 5.0))
	waves.append(Wave.new(4, [{"enemy_type":"enemy7","count":20},{"enemy_type":"bat","count":5}], 1.4, 6.0))
	waves.append(Wave.new(5, [{"enemy_type":"enemy7","count":22},{"enemy_type":"enemy8","count":8}], 1.3, 6.0))
	waves.append(Wave.new(6, [{"enemy_type":"enemy8","count":24},{"enemy_type":"bat","count":6}], 1.2, 6.0))
	waves.append(Wave.new(7, [{"enemy_type":"enemy8","count":26},{"enemy_type":"enemy9","count":10}], 1.1, 7.0))
	waves.append(Wave.new(8, [{"enemy_type":"enemy9","count":22},{"enemy_type":"bat","count":6}], 1.0, 7.0))
	waves.append(Wave.new(9, [{"enemy_type":"enemy9","count":24},{"enemy_type":"bat","count":8}], 0.9, 8.0))
	waves.append(Wave.new(10, [{"enemy_type":"enemy9","count":15},{"enemy_type":"boss2","count":1}], 0.8, 0.0))

	return waves
