extends Node
class_name WaveMap8

# Map 8 Wave Configuration - 10 Waves (Mixed / Tactical)
# Notes:
# - Mix of fast and armored units; designed for a map with alternate routes
# - Uses enemy2..enemy6 families heavily

static func get_waves() -> Array[Wave]:
	var waves: Array[Wave] = []

	# Wave 1
	waves.append(Wave.new(
		1,
		[
			{"enemy_type": "enemy1", "count": 6}
		],
		2.2,
		5.0
	))

	# Wave 2
	waves.append(Wave.new(
		2,
		[
			{"enemy_type": "enemy1", "count": 10},
			{"enemy_type": "enemy2", "count": 4}
		],
		2.0,
		5.0
	))

	# Wave 3
	waves.append(Wave.new(
		3,
		[
			{"enemy_type": "enemy2", "count": 12},
			{"enemy_type": "enemy3", "count": 4}
		],
		1.8,
		5.0
	))

	# Wave 4
	waves.append(Wave.new(
		4,
		[
			{"enemy_type": "enemy2", "count": 14},
			{"enemy_type": "enemy3", "count": 6}
		],
		1.6,
		6.0
	))

	# Wave 5
	waves.append(Wave.new(
		5,
		[
			{"enemy_type": "enemy3", "count": 12},
			{"enemy_type": "enemy4", "count": 6}
		],
		1.5,
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

	# Wave 7
	waves.append(Wave.new(
		7,
		[
			{"enemy_type": "enemy4", "count": 12},
			{"enemy_type": "enemy5", "count": 8},
			{"enemy_type": "enemy6", "count": 2}
		],
		1.1,
		7.0
	))

	# Wave 8
	waves.append(Wave.new(
		8,
		[
			{"enemy_type": "enemy3", "count": 18},
			{"enemy_type": "enemy5", "count": 10},
			{"enemy_type": "enemy6", "count": 4}
		],
		1.0,
		7.0
	))

	# Wave 9
	waves.append(Wave.new(
		9,
		[
			{"enemy_type": "enemy5", "count": 16},
			{"enemy_type": "enemy6", "count": 6}
		],
		0.9,
		8.0
	))

	# Wave 10 - Final
	waves.append(Wave.new(
		10,
		[
			{"enemy_type": "enemy3", "count": 20},
			{"enemy_type": "enemy6", "count": 8},
			{"enemy_type": "boss", "count": 1}
		],
		0.8,
		0.0
	))

	return waves
