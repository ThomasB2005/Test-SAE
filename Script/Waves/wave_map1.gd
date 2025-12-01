extends Node
class_name WaveMap1

# Map 1 Wave Configuration - 4 Waves (Tutorial/Easy)
# Progressive difficulty with enemy types: enemy1, enemy2, enemy3

static func get_waves() -> Array[Wave]:
	var waves: Array[Wave] = []
	
	# Wave 1 - Easy start with basic enemies
	waves.append(Wave.new(
		1,
		[
			{"enemy_type": "enemy1", "count": 5}
		],
		2.5,  # spawn_interval
		5.0   # wave_delay
	))
	
	# Wave 2 - More enemy1, introduction to enemy2
	waves.append(Wave.new(
		2,
		[
			{"enemy_type": "enemy1", "count": 8},
			{"enemy_type": "enemy2", "count": 2}
		],
		2.0,  # spawn_interval
		5.0   # wave_delay
	))
	
	# Wave 3 - Mixed enemies, faster spawn
	waves.append(Wave.new(
		3,
		[
			{"enemy_type": "enemy1", "count": 6},
			{"enemy_type": "enemy2", "count": 5}
		],
		1.8,  # spawn_interval
		6.0   # wave_delay
	))
	
	# Wave 4 - Boss wave with all enemy types
	waves.append(Wave.new(
		4,
		[
			{"enemy_type": "enemy1", "count": 10},
			{"enemy_type": "enemy2", "count": 5},
			{"enemy_type": "enemy3", "count": 3}
		],
		1.5,  # spawn_interval
		0.0   # wave_delay (last wave)
	))
	
	return waves
