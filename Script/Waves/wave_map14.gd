extends Node
class_name WaveMap14

# Map 14 - 10 Waves
static func get_waves() -> Array[Wave]:
    var waves: Array[Wave] = []

    waves.append(Wave.new(1, [{"enemy_type":"enemy1","count":6}], 2.4, 5.0))
    waves.append(Wave.new(2, [{"enemy_type":"enemy1","count":10},{"enemy_type":"enemy2","count":4}], 2.0, 5.0))
    waves.append(Wave.new(3, [{"enemy_type":"enemy2","count":12},{"enemy_type":"enemy3","count":6}], 1.8, 5.0))
    waves.append(Wave.new(4, [{"enemy_type":"enemy2","count":14},{"enemy_type":"enemy3","count":8}], 1.6, 6.0))
    waves.append(Wave.new(5, [{"enemy_type":"enemy3","count":12},{"enemy_type":"enemy4","count":6}], 1.5, 6.0))
    waves.append(Wave.new(6, [{"enemy_type":"enemy4","count":14},{"enemy_type":"enemy5","count":8}], 1.4, 6.0))
    waves.append(Wave.new(7, [{"enemy_type":"enemy5","count":12},{"enemy_type":"enemy6","count":8}], 1.2, 7.0))
    waves.append(Wave.new(8, [{"enemy_type":"enemy4","count":20},{"enemy_type":"enemy5","count":12}], 1.0, 7.0))
    waves.append(Wave.new(9, [{"enemy_type":"enemy5","count":22},{"enemy_type":"enemy6","count":10}], 0.9, 8.0))
    waves.append(Wave.new(10, [{"enemy_type":"enemy6","count":18}], 0.8, 0.0))

    return waves
