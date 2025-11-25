extends Node3D

# Game settings
@export var starting_hp: int = 5
@export var wave_manager: Node  # Changed from enemy_spawner to wave_manager
@export var ui_label: Label

# Game state
var player_hp: int
var is_game_over: bool = false
var waves_completed: int = 0

# Signals
signal hp_changed(new_hp)
signal game_over(reason)
signal wave_completed(wave_number)

func _ready():
	player_hp = starting_hp
	emit_signal("hp_changed", player_hp)
	
	# Connect to wave manager signals
	if wave_manager:
		if wave_manager.has_signal("wave_completed"):
			wave_manager.connect("wave_completed", _on_wave_completed)
		if wave_manager.has_signal("all_waves_completed"):
			wave_manager.connect("all_waves_completed", _on_all_waves_completed)
		# Start the waves after the WaveManager has run its _ready()
		if wave_manager.has_method("start_waves"):
			wave_manager.call_deferred("start_waves")
	
	print("Game started! HP: ", player_hp)
	update_ui()

func _process(delta):
	# Check for game over condition
	if player_hp <= 0 and not is_game_over:
		end_game("You lost! Too many enemies reached your base.")
		
	update_ui()

func take_damage(damage: int):
	if is_game_over:
		return
	
	player_hp -= damage
	emit_signal("hp_changed", player_hp)
	
	print("Player took ", damage, " damage! HP: ", player_hp)
	
	if player_hp <= 0:
		end_game("You lost! Too many enemies reached your base.")

func heal(amount: int):
	if is_game_over:
		return
	
	player_hp += amount
	emit_signal("hp_changed", player_hp)
	
	print("Player healed ", amount, " HP! HP: ", player_hp)

func end_game(reason: String):
	is_game_over = true
	emit_signal("game_over", reason)
	
	print("GAME OVER: ", reason)
	
	# Stop wave manager
	if wave_manager:
		if wave_manager.has_method("stop_waves"):
			wave_manager.call_deferred("stop_waves")
		else:
			wave_manager.is_wave_active = false

	# Show Game Over UI and pause the game
	var scene_path := "res://Scenes/UI/game_over.tscn"
	if FileAccess.file_exists(scene_path):
		var go_scene = load(scene_path)
		if go_scene:
			var go_inst = go_scene.instantiate()
			# Add to the root so it's above game content
			get_tree().get_root().add_child(go_inst)
			# make sure it gets input while paused (script also sets pause_mode)
			go_inst.owner = null
			# Pass the reason text to the UI if supported
			if go_inst.has_method("set_reason"):
				go_inst.call_deferred("set_reason", reason)
			elif go_inst.has_node("Panel/VBox/ReasonLabel"):
				go_inst.get_node("Panel/VBox/ReasonLabel").text = reason
		else:
			print("Failed to load game over scene: ", scene_path)
	else:
		print("Game over scene not found at: ", scene_path)

	# Pause the game (UI will still respond because its pause_mode is set)
	get_tree().paused = true

	# You can add more end game logic here (analytics, high score, etc.)

func _on_wave_completed(wave_number: int):
	waves_completed = wave_number
	print("Wave ", wave_number, " completed!")

func _on_all_waves_completed():
	if not is_game_over:
		end_game("Victory! You survived all waves!")

func update_ui():
	if ui_label:
		var current_wave = wave_manager.get_current_wave_number() if wave_manager else 0
		var total_waves = wave_manager.get_total_waves() if wave_manager else 0
		ui_label.text = "HP: " + str(player_hp) + "\nWave: " + str(current_wave) + "/" + str(total_waves)

func get_player_hp() -> int:
	return player_hp

func is_alive() -> bool:
	return not is_game_over
