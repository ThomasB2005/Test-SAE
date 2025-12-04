extends Node
class_name WaveMap2

# Map 2 Wave Configuration - 10 Waves (Medium Difficulty)
# Progressive difficulty with enemy types: enemy1, enemy2, enemy3, enemy4, enemy5

static func get_waves() -> Array[Wave]:
	var waves: Array[Wave] = []
	
	# Wave 1 - Warm up
	waves.append(Wave.new(
		1,
		[
			{"enemy_type": "enemy1", "count": 8}
		],
		2.0,
		5.0
	))
	
	# Wave 2 - Mixed basic enemies
	waves.append(Wave.new(
		2,
		[
			{"enemy_type": "enemy1", "count": 10},
			{"enemy_type": "enemy2", "count": 3}
		],
		1.8,
		5.0
	))
	
	# Wave 3 - More enemy2
	waves.append(Wave.new(
		3,
		[
			{"enemy_type": "enemy1", "count": 8},
			{"enemy_type": "enemy2", "count": 6}
		],
		1.7,
		5.0
	))
	
	# Wave 4 - Introduction to enemy3
	waves.append(Wave.new(
		4,
		[
			{"enemy_type": "enemy1", "count": 10},
			{"enemy_type": "enemy2", "count": 5},
			{"enemy_type": "enemy3", "count": 2}
		],
		1.6,
		6.0
	))
	
	# Wave 5 - Increased difficulty
	waves.append(Wave.new(
		5,
		[
			{"enemy_type": "enemy1", "count": 12},
			{"enemy_type": "enemy2", "count": 8},
			{"enemy_type": "enemy3", "count": 4}
		],
		1.5,
		6.0
	))
	
	# Wave 6 - Introduction to enemy4
	waves.append(Wave.new(
		6,
		[
			{"enemy_type": "enemy2", "count": 10},
			{"enemy_type": "enemy3", "count": 6},
			{"enemy_type": "enemy4", "count": 2}
		],
		1.4,
		6.0
	))
	
	# Wave 7 - Heavy wave
	waves.append(Wave.new(
		7,
		[
			{"enemy_type": "enemy1", "count": 15},
			{"enemy_type": "enemy2", "count": 10},
			{"enemy_type": "enemy3", "count": 5},
			{"enemy_type": "enemy4", "count": 3}
		],
		1.3,
		7.0
	))
	
	# Wave 8 - More enemy4
	waves.append(Wave.new(
		8,
		[
			{"enemy_type": "enemy2", "count": 12},
			{"enemy_type": "enemy3", "count": 8},
			{"enemy_type": "enemy4", "count": 6}
		],
		1.2,
		7.0
	))
	
	# Wave 9 - Introduction to enemy5
	waves.append(Wave.new(
		9,
		[
			{"enemy_type": "enemy2", "count": 10},
			{"enemy_type": "enemy3", "count": 10},
			{"enemy_type": "enemy4", "count": 5},
			{"enemy_type": "enemy5", "count": 2}
		],
		1.1,
		8.0
	))
	
	# Wave 10 - Final boss wave
	waves.append(Wave.new(
		10,
		[
			{"enemy_type": "enemy1", "count": 20},
			{"enemy_type": "enemy2", "count": 15},
			{"enemy_type": "enemy3", "count": 10},
			{"enemy_type": "enemy4", "count": 8},
			{"enemy_type": "enemy5", "count": 5}
		],
		1.0,
		0.0
	))
	
	return waves
