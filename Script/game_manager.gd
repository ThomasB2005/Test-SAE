extends Node3D

# Game settings
@export var starting_hp: int = 5
@export var enemy_spawner: Node3D
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
	
	# Connect to enemy spawner signals
	if enemy_spawner:
		if enemy_spawner.has_signal("wave_completed"):
			enemy_spawner.connect("wave_completed", _on_wave_completed)
	
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
	
	# Stop enemy spawning
	if enemy_spawner:
		enemy_spawner.stop_spawning()
	
	# You can add more end game logic here (show game over screen, etc.)

func _on_wave_completed(wave_number: int):
	waves_completed = wave_number
	print("Wave ", wave_number, " completed!")

func update_ui():
	if ui_label:
		ui_label.text = "HP: " + str(player_hp) + "\nWave: " + str(waves_completed)

func get_player_hp() -> int:
	return player_hp

func is_alive() -> bool:
	return not is_game_over
