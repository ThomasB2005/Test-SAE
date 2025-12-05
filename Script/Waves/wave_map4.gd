extends Node
class_name WaveMap4

# Map 4 Wave Configuration - 10 Waves
# Special notes:
# - This map has 2 spawners; each spawner has 2 paths.
# - Spawner 2 (index 1) should remain effectively locked for waves 1..4
#   and only become available starting with wave 5.

static func get_waves() -> Array[Wave]:
	var waves: Array[Wave] = []

	# Wave 1 - Intro
	waves.append(Wave.new(
		1,
		[
			{"enemy_type": "enemy1", "count": 6}
		],
		2.2,
		5.0
	))

	# Wave 2 - Small mixed
	waves.append(Wave.new(
		2,
		[
			{"enemy_type": "enemy1", "count": 8},
			{"enemy_type": "enemy2", "count": 2}
		],
		2.0,
		5.0
	))

	# Wave 3 - Increasing pressure
	waves.append(Wave.new(
		3,
		[
			{"enemy_type": "enemy1", "count": 10},
			{"enemy_type": "enemy2", "count": 4}
		],
		1.8,
		5.0
	))

	# Wave 4 - Last wave with single-spawner active
	waves.append(Wave.new(
		4,
		[
			{"enemy_type": "enemy2", "count": 8},
			{"enemy_type": "enemy3", "count": 2}
		],
		1.6,
		6.0
	))

	# Wave 5 - Spawner 2 unlocks now (bigger waves, multi-path)
	waves.append(Wave.new(
		5,
		[
			{"enemy_type": "enemy1", "count": 12},
			{"enemy_type": "enemy2", "count": 8},
			{"enemy_type": "enemy3", "count": 3}
		],
		1.5,
		6.0
	))

	# Wave 6
	waves.append(Wave.new(
		6,
		[
			{"enemy_type": "enemy2", "count": 12},
			{"enemy_type": "enemy3", "count": 6}
		],
		1.4,
		6.0
	))

	# Wave 7
	waves.append(Wave.new(
		7,
		[
			{"enemy_type": "enemy1", "count": 15},
			{"enemy_type": "enemy2", "count": 10},
			{"enemy_type": "enemy3", "count": 4}
		],
		1.3,
		7.0
	))

	# Wave 8
	waves.append(Wave.new(
		8,
		[
			{"enemy_type": "enemy2", "count": 14},
			{"enemy_type": "enemy3", "count": 8}
		],
		1.2,
		7.0
	))

	# Wave 9
	waves.append(Wave.new(
		9,
		[
			{"enemy_type": "enemy3", "count": 12},
			{"enemy_type": "enemy2", "count": 10}
		],
		1.1,
		8.0
	))

	# Wave 10 - Final
	waves.append(Wave.new(
		10,
		[
			{"enemy_type": "enemy1", "count": 20},
			{"enemy_type": "enemy2", "count": 15},
			{"enemy_type": "enemy3", "count": 10}
		],
		1.0,
		0.0
	))

	return waves
