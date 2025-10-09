extends Node3D

# Enemy spawning settings
@export var enemy_scene: PackedScene
@export var path_node: Path3D
@export var path_highlight: MeshInstance3D
@export var spawn_interval: float = 2.0
@export var enemies_per_wave: int = 10
@export var wave_delay: float = 5.0
@export var show_path_before_wave: bool = true
@export var auto_start: bool = true

# Current wave info
var current_wave: int = 0
var enemies_spawned_this_wave: int = 0
var is_spawning: bool = false
var spawn_timer: float = 0.0
var wave_timer: float = 0.0

# Signals
signal wave_started(wave_number)
signal wave_completed(wave_number)
signal all_waves_completed

func _ready():
	if auto_start:
		start_spawning()

func _process(delta):
	if not is_spawning:
		return
	
	spawn_timer += delta
	
	if spawn_timer >= spawn_interval:
		spawn_timer = 0.0
		spawn_enemy()

func start_spawning():
	is_spawning = true
	start_next_wave()

func stop_spawning():
	is_spawning = false

func start_next_wave():
	current_wave += 1
	enemies_spawned_this_wave = 0
	spawn_timer = 0.0
	emit_signal("wave_started", current_wave)
	print("Wave ", current_wave, " started!")

func spawn_enemy():
	if enemy_scene == null:
		push_error("Enemy scene not assigned to spawner!")
		return
	
	if path_node == null:
		push_error("Path node not assigned to spawner!")
		return
	
	var enemy_instance = enemy_scene.instantiate()
	
	path_node.add_child(enemy_instance)
	
	print("Enemy added to path, child count: ", path_node.get_child_count())
	
	enemy_instance.progress = 0
	
	if enemy_instance.has_signal("enemy_reached_end"):
		enemy_instance.connect("enemy_reached_end", _on_enemy_reached_end)
	if enemy_instance.has_signal("enemy_died"):
		enemy_instance.connect("enemy_died", _on_enemy_died)
	
	enemies_spawned_this_wave += 1
	
	# Check if wave is complete
	if enemies_spawned_this_wave >= enemies_per_wave:
		complete_wave()

func complete_wave():
	emit_signal("wave_completed", current_wave)
	print("Wave ", current_wave, " spawning complete!")
	
	# Wait before starting next wave
	is_spawning = false
	await get_tree().create_timer(wave_delay).timeout
	
	if is_spawning == false:
		start_next_wave()
		is_spawning = true

func _on_enemy_reached_end(damage):
	print("Enemy reached end! Damage: ", damage)

func _on_enemy_died():
	print("Enemy died!")
