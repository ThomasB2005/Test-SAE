extends Node
class_name WaveMap11

# Map 11 - 10 Waves
# Progression: enemy4-8 + bat
static func get_waves() -> Array[Wave]:
    var waves: Array[Wave] = []

    waves.append(Wave.new(1, [{"enemy_type":"enemy4","count":12}], 1.9, 5.0))
    waves.append(Wave.new(2, [{"enemy_type":"enemy4","count":14},{"enemy_type":"enemy5","count":4}], 1.8, 5.0))
    waves.append(Wave.new(3, [{"enemy_type":"enemy5","count":16},{"enemy_type":"bat","count":4}], 1.7, 5.0))
    waves.append(Wave.new(4, [{"enemy_type":"enemy5","count":18},{"enemy_type":"enemy6","count":6}], 1.6, 6.0))
    waves.append(Wave.new(5, [{"enemy_type":"enemy6","count":20},{"enemy_type":"bat","count":5}], 1.5, 6.0))
    waves.append(Wave.new(6, [{"enemy_type":"enemy6","count":22},{"enemy_type":"enemy7","count":7}], 1.4, 6.0))
    waves.append(Wave.new(7, [{"enemy_type":"enemy7","count":20},{"enemy_type":"enemy8","count":8}], 1.3, 7.0))
    waves.append(Wave.new(8, [{"enemy_type":"enemy7","count":22},{"enemy_type":"enemy8","count":10}], 1.2, 7.0))
    waves.append(Wave.new(9, [{"enemy_type":"enemy8","count":24},{"enemy_type":"bat","count":6}], 1.1, 8.0))
    waves.append(Wave.new(10, [{"enemy_type":"enemy8","count":18}], 1.0, 0.0))

    return waves
