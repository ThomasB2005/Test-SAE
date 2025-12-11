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
var map25_spawner10_count: int = 0  # Counter for spawner10 usage on map25

# Signals
signal wave_started(wave_number)
signal wave_completed(wave_number)
signal all_waves_completed


func _load_waves_for_map(t: String) -> Array:
	var script_path := "res://Script/Waves/wave_" + t + ".gd"
	if FileAccess.file_exists(script_path):
		var scr = load(script_path)
		if scr and scr.has_method("get_waves"):
			return scr.get_waves()
		else:
			push_error("WaveManager: script found but no get_waves() in: " + script_path)
			return []
	else:
		push_error("Invalid map type or missing wave script: " + t + " (expected " + script_path + ")")
		return []

func _ready():
	print("WaveManager._ready: node=", get_path(), " map_type=", map_type)
	# Load waves using the loader helper (keeps code robust for newly added scripts)
	waves = _load_waves_for_map(map_type)

	# Diagnostic: print which WaveMap provided the waves count
	print("WaveManager: loaded ", waves.size(), " waves for map_type=", map_type)
	
	# Disable all spawners (we'll control them manually)
	# If no spawners were assigned in the inspector, try to auto-discover them
	if spawners.is_empty():
		discover_spawners()

	# Diagnostic: list discovered/configured spawners
	if spawners and spawners.size() > 0:
		var names = []
		for s in spawners:
			if s:
				names.append(str(s.get_path()))
			else:
				names.append("<null>")
		print("WaveManager: configured/discovered spawners = ", names)

	for spawner in spawners:
		if not spawner:
			continue
		# Only touch these properties if the spawner object actually exposes them
		if "is_spawning" in spawner:
			spawner.is_spawning = false
		if "auto_start" in spawner:
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
	map25_spawner10_count = 0  # Reset counter for new wave
	
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

func discover_spawners():
	# Try to find spawner nodes in this scene if none were configured in the inspector.
	var found: Array[Node] = []
	var root_node: Node = get_parent() if get_parent() else get_tree().get_root()
	_collect_spawners_recursive(root_node, found)
	if found.size() > 0:
		spawners = found
		print("WaveManager: auto-discovered ", found.size(), " spawners")
	else:
		push_error("WaveManager: auto-discovery found no spawners in scene tree")

func _collect_spawners_recursive(node: Node, out_array: Array[Node]) -> void:
	for c in node.get_children():
		if c == null:
			continue
		# Heuristic: spawner script exposes `start_spawning`, or has `path_node`/`path_nodes` properties
		if c.has_method("start_spawning") or ("path_node" in c) or ("path_nodes" in c):
			out_array.append(c)
		# Recurse into children
		_collect_spawners_recursive(c, out_array)

func spawn_enemy_on_spawner(spawner: Node, enemy_type: String):
	# Get the enemy scene based on enemy_type
	var enemy_scene = get_enemy_scene(enemy_type)
	
	if enemy_scene == null:
		push_error("Enemy scene not found for type: " + enemy_type)
		return

	# Determine which path to use for this spawn.
	var chosen_path = null

	# Special-case: Bosses on certain maps always use the second path
	var is_boss_spawn = is_enemy_boss(enemy_type)
	if is_boss_spawn and (map_type == "map5" or map_type == "map10" or map_type == "map15" or map_type == "map20" or map_type == "map25"):
		# Force the boss to use the second path regardless of other rules
		if ("path_nodes" in spawner) and spawner.path_nodes and spawner.path_nodes.size() >= 2:
			var entry = spawner.path_nodes[1]
			if entry is Path3D:
				chosen_path = entry
			else:
				# Try to resolve node path/string entries
				var resolved = null
				if typeof(entry) == TYPE_NODE_PATH or typeof(entry) == TYPE_STRING:
					resolved = spawner.get_node_or_null(entry)
				if resolved and resolved is Path3D:
					chosen_path = resolved

	# If path not chosen yet (not a boss or boss logic didn't apply), use normal logic
	if chosen_path == null:
		# If the spawner exposes multiple paths, and we're before wave 8, prefer the first path only.
		var before_wave_8 := true
		if current_wave:
			before_wave_8 = current_wave.wave_number < 8

		if ("path_nodes" in spawner) and spawner.path_nodes and spawner.path_nodes.size() >= 1:
			# If multiple paths and we're still before wave 8, force the first path.
			if spawner.path_nodes.size() >= 2 and before_wave_8:
				var entry0 = spawner.path_nodes[0]
				if entry0 is Path3D:
					chosen_path = entry0
				else:
					var resolved0 = null
					if typeof(entry0) == TYPE_NODE_PATH or typeof(entry0) == TYPE_STRING:
						resolved0 = spawner.get_node_or_null(entry0)
					if resolved0 and resolved0 is Path3D:
						chosen_path = resolved0
			else:
				# Otherwise, prefer letting the spawner decide if it has a helper method, fallback to first path
				if spawner.has_method("get_spawn_path"):
					chosen_path = spawner.call("get_spawn_path")
				else:
					var entry_fallback = spawner.path_nodes[0]
					if entry_fallback is Path3D:
						chosen_path = entry_fallback
					else:
						var resolved_fb = null
						if typeof(entry_fallback) == TYPE_NODE_PATH or typeof(entry_fallback) == TYPE_STRING:
							resolved_fb = spawner.get_node_or_null(entry_fallback)
						if resolved_fb and resolved_fb is Path3D:
							chosen_path = resolved_fb
		else:
			# Try to use a direct `path_node` property if present on the spawner
			if spawner.has_method("get_spawn_path"):
				chosen_path = spawner.call("get_spawn_path")
			else:
				if "path_node" in spawner:
					chosen_path = spawner.path_node

	if chosen_path == null:
		push_error("Path node not assigned to spawner!")
		return

	var enemy_instance = enemy_scene.instantiate()
	chosen_path.add_child(enemy_instance)
	enemy_instance.progress = 0
	
	# Add vertical offset to prevent enemies from being in the ground
	if enemy_instance is PathFollow3D:
		enemy_instance.v_offset = 0.5  # Adjust this value as needed
	
	# Connect enemy signals
	if enemy_instance.has_signal("enemy_reached_end"):
		enemy_instance.connect("enemy_reached_end", _on_enemy_reached_end)
	if enemy_instance.has_signal("enemy_died"):
		enemy_instance.connect("enemy_died", _on_enemy_died)
	
	enemies_alive += 1
	print("Spawned ", enemy_type, " on spawner. Enemies alive: ", enemies_alive)

# Helper function to check if an enemy type is a boss by loading its scene
func is_enemy_boss(enemy_type: String) -> bool:
	var enemy_scene = get_enemy_scene(enemy_type)
	if enemy_scene == null:
		print("DEBUG is_enemy_boss: enemy_scene is null for ", enemy_type)
		return false
	
	# Instantiate temporarily to check the is_boss variable
	var temp_instance = enemy_scene.instantiate()
	var is_boss_value = false
	
	print("DEBUG is_enemy_boss: instantiated ", enemy_type)
	
	# Add to tree so _ready() is called
	add_child(temp_instance)
	
	# The script might be on a child node (Node3D), not the root
	# Check the root first
	if "is_boss" in temp_instance:
		is_boss_value = temp_instance.is_boss
		print("DEBUG is_enemy_boss: Found is_boss on root, value=", is_boss_value)
	else:
		# Check children (especially Node3D)
		for child in temp_instance.get_children():
			if "is_boss" in child:
				is_boss_value = child.is_boss
				print("DEBUG is_enemy_boss: Found is_boss on child ", child.name, ", value=", is_boss_value)
				break
	
	# Clean up the temporary instance
	temp_instance.queue_free()
	
	return is_boss_value

func get_spawners_for_enemy(enemy_type: String) -> Array:
	var result: Array = []
	if spawners.is_empty():
		push_error("WaveManager: no spawners assigned (spawners array empty). map_type=" + str(map_type) + " current_wave_index=" + str(current_wave_index))
		return result

	var two_spawners: bool = spawners.size() >= 2

	var is_boss_enemy = is_enemy_boss(enemy_type)
	print("DEBUG get_spawners_for_enemy: enemy_type=", enemy_type, " is_boss=", is_boss_enemy, " map_type=", map_type, " spawners.size()=", spawners.size(), " wave_index=", current_wave_index)
	if is_boss_enemy:
		# Map20: boss uses Enemy_spawn4 (index 2 in array)
		if map_type == "map20" and spawners.size() >= 4:
			print("DEBUG: Boss on map20, using spawner[2] =", spawners[2].name if spawners[2] else "null")
			result.append(spawners[2])
			return result
		# Map25: boss uses spawner9 (index 8)
		if map_type == "map25" and spawners.size() >= 10:
			result.append(spawners[8])
			return result

	if current_wave_index == 0:
		result.append(spawners[0])
		return result

	# Special handling for certain maps
	if map_type == "map4":
		if current_wave_index < 4:
			result.append(spawners[0])
			return result
			
	if map_type == "map6":
		if current_wave_index < 3:
			result.append(spawners[0])
			return result
	
	# Special logic for bat
	if map_type == "map20" and spawners.size() >= 4:
		if enemy_type.to_lower() == "bat":
			result.append(spawners[3])
			return result
	
	# Special logic for map25 spawner7 (index 6), spawner8 (index 7), spawner9 (index 8) and spawner10 (index 9)
	if map_type == "map25" and spawners.size() >= 10:
		# Spawner7 and spawner8 are only for bat enemy
		if enemy_type.to_lower() == "bat":
			# Alternate between spawner7 and spawner8
			if randi() % 2 == 0:
				result.append(spawners[6])  # spawner7
			else:
				result.append(spawners[7])  # spawner8
			return result
		
		# Spawner10 logic
		var spawner10 = spawners[9]
		var max_uses = 0
		
		# Wave 4 (index 3): 2 enemies, Wave 6 (index 5): 2 enemies, Wave 8 (index 7): 3 enemies
		if current_wave_index == 3:  # Wave 4
			max_uses = 2
		elif current_wave_index == 5:  # Wave 6
			max_uses = 2
		elif current_wave_index == 7:  # Wave 8
			max_uses = 3
		
		if max_uses > 0 and map25_spawner10_count < max_uses:
			map25_spawner10_count += 1
			result.append(spawner10)
			return result
		elif max_uses > 0:
			# Already reached limit for spawner10, use other spawners
			result.append(get_next_spawner())
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
		"enemy3":
			if two_spawners:
				result.append(spawners[1])
			else:
				result.append(spawners[0])
		_:
			# Fallback: round-robin (exclude spawner7-10 on map25, exclude spawner4 on map20)
			if map_type == "map25" and spawners.size() >= 10:
				# Use only spawners 0-5 for round-robin on map25
				var limited_index = current_spawner_index % 6
				current_spawner_index = (current_spawner_index + 1) % 6
				result.append(spawners[limited_index])
			elif map_type == "map20" and spawners.size() >= 4:
				# Use only spawners 0-2 for round-robin on map20 (exclude spawner4)
				var limited_index = current_spawner_index % 3
				current_spawner_index = (current_spawner_index + 1) % 3
				result.append(spawners[limited_index])
			else:
				result.append(get_next_spawner())

	# If we somehow produced no spawners, fall back to the first configured spawner
	if result.is_empty() and spawners.size() > 0:
		print("WaveManager: get_spawners_for_enemy fallback used for map=", map_type, " wave_index=", current_wave_index, " enemy=", enemy_type)
		result.append(spawners[0])

	return result

func get_enemy_scene(enemy_type: String) -> PackedScene:
	# Map enemy type names to actual scene paths
	# TODO: Replace these paths with your actual enemy scenes
	match enemy_type:
		"enemy1":
			return load("res://Scenes/Enemy/slime.tscn")
		"enemy2":
			return load("res://Scenes/Enemy/Spider.tscn")
		"enemy3":
			return load("res://Scenes/Enemy/Skeleton.tscn")
		"enemy4":
			return load("res://Scenes/Enemy/Goblin.tscn")
		"enemy5":
			return load("res://Scenes/Enemy/Mushroom.tscn")
		"enemy6":
			return load("res://Scenes/Enemy/PiranhaPlant.tscn")
		"enemy7":
			return load("res://Scenes/Enemy/Wizard1.tscn")
		"enemy8":
			return load("res://Scenes/Enemy/Wizard2.tscn")
		"enemy9":
			return load("res://Scenes/Enemy/IronGolem.tscn")
		"bat":
			return load("res://Scenes/Enemy/Bat.tscn")
		"boss":
			return load("res://Scenes/Enemy/Boss/Sprout.tscn")
		"boss2":
			return load("res://Scenes/Enemy/Boss/OldGuardian.tscn")
		"boss3":
			return load("res://Scenes/Enemy/Boss/SkeletonSeeker.tscn")
		"boss4":
			return load("res://Scenes/Enemy/Boss/BringerOfDeath.tscn")
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
