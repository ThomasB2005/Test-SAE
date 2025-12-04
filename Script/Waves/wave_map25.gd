extends Node
class_name WaveMap25

# Map 25 - final map, boss placeholder 'boss5' on final wave
static func get_waves() -> Array[Wave]:
	var waves: Array[Wave] = []

	waves.append(Wave.new(1, [{"enemy_type":"enemy8","count":20}], 1.4, 5.0))
	waves.append(Wave.new(2, [{"enemy_type":"enemy8","count":22},{"enemy_type":"enemy9","count":8}], 1.3, 5.0))
	waves.append(Wave.new(3, [{"enemy_type":"enemy9","count":24},{"enemy_type":"bat","count":8}], 1.2, 5.0))
	waves.append(Wave.new(4, [{"enemy_type":"enemy9","count":26},{"enemy_type":"bat","count":10}], 1.1, 6.0))
	waves.append(Wave.new(5, [{"enemy_type":"enemy9","count":28},{"enemy_type":"bat","count":10}], 1.0, 6.0))
	waves.append(Wave.new(6, [{"enemy_type":"enemy9","count":30},{"enemy_type":"bat","count":12}], 0.9, 6.0))
	waves.append(Wave.new(7, [{"enemy_type":"enemy9","count":32},{"enemy_type":"bat","count":14}], 0.8, 7.0))
	waves.append(Wave.new(8, [{"enemy_type":"enemy9","count":28},{"enemy_type":"bat","count":12}], 0.7, 7.0))
	waves.append(Wave.new(9, [{"enemy_type":"enemy9","count":30},{"enemy_type":"bat","count":14}], 0.6, 8.0))
	waves.append(Wave.new(10, [{"enemy_type":"enemy9","count":22},{"enemy_type":"boss5","count":1}], 0.5, 0.0))

	return waves
