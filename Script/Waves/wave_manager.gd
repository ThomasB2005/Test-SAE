extends Node
class_name WaveManager

# Wave Manager - Coordinates multiple spawners for multi-path maps
# Handles wave progression and enemy distribution across spawners

@export var spawners: Array[Node] = []  # Array of spawner nodes
@export var game_manager: Node
@export var map_type: String = "map1"
@export var endless: bool = false

var waves: Array[Wave] = []
var current_wave_index: int = -1
var current_wave: Wave = null
var is_wave_active: bool = false
var enemies_alive: int = 0
var spawn_queue: Array = []  # Queue of enemies to spawn
var spawn_timer: float = 0.0
var current_spawner_index: int = 0
var stopped: bool = false

# Signals
signal wave_started(wave_number)
signal wave_completed(wave_number)
signal all_waves_completed

func _ready():
	# Load waves based on map type
	match map_type:
		"map1":
			waves = WaveMap1.get_waves()
		"map2":
			waves = WaveMap2.get_waves()
		"map3":
			waves = WaveMap3.get_waves()
		_:
			push_error("Invalid map type: " + map_type)
			return
	
	# Disable all spawners (we'll control them manually)
	for spawner in spawners:
		if spawner:
			spawner.is_spawning = false
			spawner.auto_start = false
	
	print("Wave Manager initialized with ", waves.size(), " waves for ", map_type)

func _process(delta):
	if not is_wave_active or spawn_queue.is_empty():
		return
	
	spawn_timer += delta
	
	if spawn_timer >= current_wave.spawn_interval:
		spawn_timer = 0.0
		spawn_next_enemy()

func start_waves():
	if waves.is_empty():
		push_error("No waves configured!")
		return
	
	start_next_wave()

func start_next_wave():
	if stopped:
		print("WaveManager: start_next_wave aborted because stopped flag is set")
		return
	current_wave_index += 1
	
	if current_wave_index >= waves.size():
		complete_all_waves()
		return
	
	current_wave = waves[current_wave_index]
	is_wave_active = true
	spawn_timer = 0.0
	
	# Build spawn queue from current wave
	build_spawn_queue()
	
	emit_signal("wave_started", current_wave.wave_number)
	print("Wave ", current_wave.wave_number, " started! Total enemies: ", spawn_queue.size())

func build_spawn_queue():
	spawn_queue.clear()
	
	# Add all enemies from the wave to the queue
	for enemy_group in current_wave.enemies:
		var enemy_type = enemy_group["enemy_type"]
		var count = enemy_group["count"]
		
		for i in range(count):
			spawn_queue.append(enemy_type)
	
	# Shuffle queue for variety (optional)
	spawn_queue.shuffle()

func spawn_next_enemy():
	if spawn_queue.is_empty():
		return
	
	var enemy_type = spawn_queue.pop_front()

	# Determine which spawners should spawn this enemy according to rules:
	# - First wave: always use spawner 0
	# - Middle waves: map certain enemy types to specific spawners (enemy2 -> spawner 0, enemy3 -> spawner 1)
	# - Last two waves: spawn the enemy on all spawners simultaneously
	var target_spawners: Array = get_spawners_for_enemy(enemy_type)
	if target_spawners.is_empty():
		push_error("No valid spawner available for enemy: " + enemy_type)
		return

	# Spawn the enemy on each selected spawner
	for spawner in target_spawners:
		spawn_enemy_on_spawner(spawner, enemy_type)
	
	# Check if wave spawning is complete
	if spawn_queue.is_empty():
		finish_wave_spawning()

func get_next_spawner() -> Node:
	if spawners.is_empty():
		return null

	# Round-robin distribution (fallback)
	current_spawner_index = (current_spawner_index + 1) % spawners.size()
	return spawners[current_spawner_index]
	
	# Alternative: Random spawner
	# return spawners[randi() % spawners.size()]

func spawn_enemy_on_spawner(spawner: Node, enemy_type: String):
	# Get the enemy scene based on enemy_type
	var enemy_scene = get_enemy_scene(enemy_type)
	
	if enemy_scene == null:
		push_error("Enemy scene not found for type: " + enemy_type)
		return
	
	var path_node = spawner.path_node
	
	if path_node == null:
		push_error("Path node not assigned to spawner!")
		return
	
	var enemy_instance = enemy_scene.instantiate()
	path_node.add_child(enemy_instance)
	enemy_instance.progress = 0
	
	# Connect enemy signals
	if enemy_instance.has_signal("enemy_reached_end"):
		enemy_instance.connect("enemy_reached_end", _on_enemy_reached_end)
	if enemy_instance.has_signal("enemy_died"):
		enemy_instance.connect("enemy_died", _on_enemy_died)
	
	enemies_alive += 1
	print("Spawned ", enemy_type, " on spawner. Enemies alive: ", enemies_alive)


func get_spawners_for_enemy(enemy_type: String) -> Array:
	var result: Array = []
	if spawners.is_empty():
		return result

	var two_spawners: bool = spawners.size() >= 2

	if current_wave_index == 0:
		result.append(spawners[0])
		return result

	var last_two_start: int = waves.size() - 2
	if last_two_start < 0:
		last_two_start = 0
	if current_wave_index >= last_two_start:
		for s in spawners:
			result.append(s)
		return result

	# Middle waves: map enemy types to spawners
	match enemy_type:
		"enemy2":
			result.append(spawners[0])
			return result
		"enemy3":
			if two_spawners:
				result.append(spawners[1])
			else:
				result.append(spawners[0])
			return result
		_:
			# Fallback: round-robin
			result.append(get_next_spawner())
			return result

func get_enemy_scene(enemy_type: String) -> PackedScene:
	# Map enemy type names to actual scene paths
	# TODO: Replace these paths with your actual enemy scenes
	match enemy_type:
		"enemy1":
			return load("res://Scenes/Enemy/Enemy.tscn")  # Replace with actual path
		"enemy2":
			return load("res://Scenes/Enemy/Enemy.tscn")  # Replace with enemy2 scene
		"enemy3":
			return load("res://Scenes/Enemy/Enemy.tscn")  # Replace with enemy3 scene
		"enemy4":
			return load("res://Scenes/Enemy/Enemy.tscn")  # Replace with enemy4 scene
		"enemy5":
			return load("res://Scenes/Enemy/Enemy.tscn")  # Replace with enemy5 scene
		"enemy6":
			return load("res://Scenes/Enemy/Enemy.tscn")  # Replace with enemy6 scene
		_:
			push_error("Unknown enemy type: " + enemy_type)
			return null

func finish_wave_spawning():
	print("Wave ", current_wave.wave_number, " spawning complete. Waiting for enemies to die...")
	# Wait for all enemies to be defeated before starting next wave
	if stopped:
		print("WaveManager: finish_wave_spawning aborted because stopped")
		return
	check_wave_completion()

func check_wave_completion():
	if enemies_alive <= 0 and spawn_queue.is_empty():
		complete_wave()

func complete_wave():
	if stopped:
		print("WaveManager: complete_wave aborted because stopped")
		is_wave_active = false
		return

	is_wave_active = false
	emit_signal("wave_completed", current_wave.wave_number)
	print("Wave ", current_wave.wave_number, " completed!")

	# Wait before starting next wave
	if current_wave_index < waves.size() - 1:
		await get_tree().create_timer(current_wave.wave_delay).timeout
		if not stopped:
			start_next_wave()
	else:
		complete_all_waves()

func complete_all_waves():
	print("All waves completed! Victory!")
	emit_signal("all_waves_completed")

	# If endless mode is enabled, restart wave progression from the beginning
	if endless:
		print("WaveManager: endless mode enabled, restarting waves...")
		# small delay before restarting
		await get_tree().create_timer(2.0).timeout
		# reset wave index so start_next_wave increments to first wave
		current_wave_index = -1
		start_next_wave()

func _on_enemy_reached_end(damage: int):
	enemies_alive -= 1
	print("Enemy reached end! Damage: ", damage, " Enemies alive: ", enemies_alive)
	
	if game_manager:
		game_manager.take_damage(damage)
	
	check_wave_completion()

func _on_enemy_died():
	enemies_alive -= 1
	print("Enemy died! Enemies alive: ", enemies_alive)
	check_wave_completion()

func stop_waves():
	stopped = true
	is_wave_active = false
	spawn_queue.clear()
	print("WaveManager: stopped by GameManager")

func get_current_wave_number() -> int:
	return current_wave.wave_number if current_wave else 0

func get_total_waves() -> int:
	return waves.size()

func is_endless() -> bool:
	# Checks if the game is running on endless mode
	return endless
