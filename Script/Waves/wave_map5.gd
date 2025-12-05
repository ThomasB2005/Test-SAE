extends Node
class_name WaveMap5

# Map 5 Wave Configuration - 10 Waves
# - This map has a single spawner that exposes 2 paths (`Path3D` and `Path3D2`).
# - A boss appears on wave 10 and must use the second path.

static func get_waves() -> Array[Wave]:
	var waves: Array[Wave] = []

	# Wave 1
	waves.append(Wave.new(
		1,
		[
			{"enemy_type": "enemy1", "count": 8},
		],
		2.0,
		5.0
	))

	# Wave 2
	waves.append(Wave.new(
		2,
		[
			{"enemy_type": "enemy1", "count": 10},
			{"enemy_type": "enemy2", "count": 2}
		],
		1.8,
		5.0
	))

	# Wave 3
	waves.append(Wave.new(
		3,
		[
			{"enemy_type": "enemy1", "count": 12},
			{"enemy_type": "enemy2", "count": 4}
		],
		1.7,
		5.0
	))

	# Wave 4
	waves.append(Wave.new(
		4,
		[
			{"enemy_type": "enemy2", "count": 8},
			{"enemy_type": "enemy3", "count": 2}
		],
		1.6,
		6.0
	))

	# Wave 5
	waves.append(Wave.new(
		5,
		[
			{"enemy_type": "enemy1", "count": 14},
			{"enemy_type": "enemy2", "count": 8}
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
			{"enemy_type": "enemy1", "count": 16},
			{"enemy_type": "enemy2", "count": 12},
			{"enemy_type": "enemy3", "count": 4}
		],
		1.3,
		7.0
	))

	# Wave 8
	waves.append(Wave.new(
		8,
		[
			{"enemy_type": "enemy2", "count": 18},
			{"enemy_type": "enemy3", "count": 8}
		],
		1.2,
		7.0
	))

	# Wave 9
	waves.append(Wave.new(
		9,
		[
			{"enemy_type": "enemy3", "count": 14},
			{"enemy_type": "enemy2", "count": 12}
		],
		1.1,
		8.0
	))

	# Wave 10 - Boss wave (boss uses second path)
	waves.append(Wave.new(
		10,
		[
			{"enemy_type": "enemy1", "count": 10},
			{"enemy_type": "enemy2", "count": 10},
			{"enemy_type": "boss", "count": 1}
		],
		1.0,
		0.0
	))

	return waves
