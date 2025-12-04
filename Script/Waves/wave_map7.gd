extends Node
class_name WaveMap7

# Map 7 Wave Configuration - 10 Waves (Very Hard)
# Notes:
# - Increased presence of armored and flying units (enemy6, enemy7)
# - Suitable for maps with chokepoints

static func get_waves() -> Array[Wave]:
	var waves: Array[Wave] = []

	# Wave 1
	waves.append(Wave.new(
		1,
		[
			{"enemy_type": "enemy1", "count": 8},
			{"enemy_type": "enemy2", "count": 2}
		],
		2.0,
		5.0
	))

	# Wave 2
	waves.append(Wave.new(
		2,
		[
			{"enemy_type": "enemy1", "count": 12},
			{"enemy_type": "enemy2", "count": 5}
		],
		1.8,
		5.0
	))

	# Wave 3
	waves.append(Wave.new(
		3,
		[
			{"enemy_type": "enemy2", "count": 10},
			{"enemy_type": "enemy3", "count": 6}
		],
		1.6,
		5.0
	))

	# Wave 4
	waves.append(Wave.new(
		4,
		[
			{"enemy_type": "enemy3", "count": 12},
			{"enemy_type": "enemy4", "count": 4}
		],
		1.5,
		6.0
	))

	# Wave 5
	waves.append(Wave.new(
		5,
		[
			{"enemy_type": "enemy3", "count": 14},
			{"enemy_type": "enemy4", "count": 8}
		],
		1.4,
		6.0
	))

	# Wave 6
	waves.append(Wave.new(
		6,
		[
			{"enemy_type": "enemy4", "count": 10},
			{"enemy_type": "enemy5", "count": 6}
		],
		1.3,
		6.0
	))

	# Wave 7 - flying units appear
	waves.append(Wave.new(
		7,
		[
			{"enemy_type": "enemy5", "count": 8},
			{"enemy_type": "enemy6", "count": 4},
			{"enemy_type": "enemy7", "count": 2}
		],
		1.1,
		7.0
	))

	# Wave 8
	waves.append(Wave.new(
		8,
		[
			{"enemy_type": "enemy4", "count": 16},
			{"enemy_type": "enemy5", "count": 12},
			{"enemy_type": "enemy6", "count": 6}
		],
		1.0,
		7.0
	))

	# Wave 9
	waves.append(Wave.new(
		9,
		[
			{"enemy_type": "enemy5", "count": 18},
			{"enemy_type": "enemy6", "count": 8},
			{"enemy_type": "enemy7", "count": 4}
		],
		0.9,
		8.0
	))

	# Wave 10 - Final boss barrage
	waves.append(Wave.new(
		10,
		[
			{"enemy_type": "enemy3", "count": 20},
			{"enemy_type": "enemy6", "count": 12},
			{"enemy_type": "boss", "count": 1}
		],
		0.8,
		0.0
	))

	return waves
