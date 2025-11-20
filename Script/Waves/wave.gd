extends Resource
class_name Wave

# Wave configuration
@export var wave_number: int = 1
@export var enemies: Array[Dictionary] = []  # Array of {enemy_type: String, count: int}
@export var spawn_interval: float = 2.0  # Time between enemy spawns
@export var wave_delay: float = 5.0  # Delay before next wave starts

# Example structure for enemies array:
# [{enemy_type: "enemy1", count: 5}, {enemy_type: "enemy2", count: 3}]

func _init(wave_num: int = 1, enemy_data: Array[Dictionary] = [], interval: float = 2.0, delay: float = 5.0):
	wave_number = wave_num
	enemies = enemy_data
	spawn_interval = interval
	wave_delay = delay

func get_total_enemy_count() -> int:
	var total = 0
	for enemy_group in enemies:
		if enemy_group.has("count"):
			total += enemy_group["count"]
	return total
