extends Node
class_name WaveMap3

# Map 3 Wave Configuration - 10 Waves (Hard Difficulty)
# Progressive difficulty with enemy types: enemy1, enemy2, enemy3, enemy4, enemy5, enemy6

static func get_waves() -> Array[Wave]:
	var waves: Array[Wave] = []
	
	# Wave 1 - Strong start
	waves.append(Wave.new(
		1,
		[
			{"enemy_type": "enemy1", "count": 12},
			{"enemy_type": "enemy2", "count": 4}
		],
		1.8,
		5.0
	))
	
	# Wave 2 - Mixed assault
	waves.append(Wave.new(
		2,
		[
			{"enemy_type": "enemy1", "count": 15},
			{"enemy_type": "enemy2", "count": 8},
			{"enemy_type": "enemy3", "count": 3}
		],
		1.6,
		5.0
	))
	
	# Wave 3 - Heavy pressure
	waves.append(Wave.new(
		3,
		[
			{"enemy_type": "enemy2", "count": 12},
			{"enemy_type": "enemy3", "count": 8},
			{"enemy_type": "enemy4", "count": 2}
		],
		1.5,
		5.0
	))
	
	# Wave 4 - Introduction to enemy4
	waves.append(Wave.new(
		4,
		[
			{"enemy_type": "enemy1", "count": 18},
			{"enemy_type": "enemy2", "count": 10},
			{"enemy_type": "enemy3", "count": 6},
			{"enemy_type": "enemy4", "count": 4}
		],
		1.4,
		6.0
	))
	
	# Wave 5 - Escalating threat
	waves.append(Wave.new(
		5,
		[
			{"enemy_type": "enemy2", "count": 15},
			{"enemy_type": "enemy3", "count": 12},
			{"enemy_type": "enemy4", "count": 6},
			{"enemy_type": "enemy5", "count": 3}
		],
		1.3,
		6.0
	))
	
	# Wave 6 - More enemy5
	waves.append(Wave.new(
		6,
		[
			{"enemy_type": "enemy2", "count": 12},
			{"enemy_type": "enemy3", "count": 15},
			{"enemy_type": "enemy4", "count": 8},
			{"enemy_type": "enemy5", "count": 5}
		],
		1.2,
		6.0
	))
	
	# Wave 7 - Introduction to enemy6
	waves.append(Wave.new(
		7,
		[
			{"enemy_type": "enemy3", "count": 18},
			{"enemy_type": "enemy4", "count": 10},
			{"enemy_type": "enemy5", "count": 6},
			{"enemy_type": "enemy6", "count": 2}
		],
		1.1,
		7.0
	))
	
	# Wave 8 - Intense assault
	waves.append(Wave.new(
		8,
		[
			{"enemy_type": "enemy2", "count": 20},
			{"enemy_type": "enemy3", "count": 15},
			{"enemy_type": "enemy4", "count": 12},
			{"enemy_type": "enemy5", "count": 8},
			{"enemy_type": "enemy6", "count": 4}
		],
		1.0,
		7.0
	))
	
	# Wave 9 - Pre-final challenge
	waves.append(Wave.new(
		9,
		[
			{"enemy_type": "enemy3", "count": 20},
			{"enemy_type": "enemy4", "count": 15},
			{"enemy_type": "enemy5", "count": 10},
			{"enemy_type": "enemy6", "count": 6}
		],
		0.9,
		8.0
	))
	
	# Wave 10 - Ultimate boss wave
	waves.append(Wave.new(
		10,
		[
			{"enemy_type": "enemy1", "count": 25},
			{"enemy_type": "enemy2", "count": 20},
			{"enemy_type": "enemy3", "count": 18},
			{"enemy_type": "enemy4", "count": 15},
			{"enemy_type": "enemy5", "count": 12},
			{"enemy_type": "enemy6", "count": 10}
		],
		0.8,
		0.0
	))
	
	return waves
