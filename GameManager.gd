# GameManager.gd → À METTRE EN AUTOLOAD !
extends Node3D

# ─────────────────────────────────────
# GAME SETTINGS (visible dans l'éditeur)
# ─────────────────────────────────────
@export var starting_hp: int = 5
@export var wave_manager: Node
@export var ui_label: Label

# ─────────────────────────────────────
# GAME STATE
# ─────────────────────────────────────
var player_hp: int
var is_game_over: bool = false
var waves_completed: int = 0

# Ajout indispensable pour la boutique
var selected_turret: Node = null          # ← Tourelle actuellement sélectionnée
var gold: int = 5000                      # ← Or du joueur (partagé avec le menu pause)

# ─────────────────────────────────────
# SIGNALS
# ─────────────────────────────────────
signal hp_changed(new_hp)
signal gold_changed(new_gold)
signal game_over(reason)
signal wave_completed(wave_number)

# ─────────────────────────────────────
# GODOT CALLBACKS
# ─────────────────────────────────────
func _ready():
	player_hp = starting_hp
	emit_signal("hp_changed", player_hp)
	emit_signal("gold_changed", gold)
	
	if wave_manager:
		if wave_manager.has_signal("wave_completed"):
			wave_manager.connect("wave_completed", _on_wave_completed)
		if wave_manager.has_signal("all_waves_completed"):
			wave_manager.connect("all_waves_completed", _on_all_waves_completed)
		if wave_manager.has_method("start_waves"):
			wave_manager.call_deferred("start_waves")
	
	print("Game started! HP: ", player_hp, " | Gold: ", gold)
	update_ui()

func _process(_delta):
	if player_hp <= 0 and not is_game_over:
		end_game("Vous avez perdu ! Trop d'ennemis sont passés.")

# ─────────────────────────────────────
# FONCTIONS PUBLIQUES
# ─────────────────────────────────────
func take_damage(damage: int):
	if is_game_over: return
	player_hp = max(player_hp - damage, 0)
	emit_signal("hp_changed", player_hp)
	print("Player took ", damage, " damage → HP: ", player_hp)
	if player_hp <= 0:
		end_game("Vous avez perdu ! Trop d'ennemis sont passés.")

func heal(amount: int):
	if is_game_over: return
	player_hp += amount
	emit_signal("hp_changed", player_hp)

func add_gold(amount: int):
	gold += amount
	emit_signal("gold_changed", gold)
	print("+$", amount, " → Or total: ", gold)

func spend_gold(amount: int) -> bool:
	if gold >= amount:
		gold -= amount
		emit_signal("gold_changed", gold)
		return true
	return false

func select_turret(turret: Node):
	if selected_turret == turret:
		selected_turret = null          # Clic sur la même = désélection
	else:
		selected_turret = turret
	print("Tourelle sélectionnée :", selected_turret)

func end_game(reason: String):
	if is_game_over: return
	is_game_over = true
	emit_signal("game_over", reason)
	print("GAME OVER → ", reason)
	
	if wave_manager and wave_manager.has_method("stop_waves"):
		wave_manager.call_deferred("stop_waves")
	
	# Chargement de l'écran Game Over
	var go_scene_path = "res://Scenes/UI/game_over.tscn"
	if ResourceLoader.exists(go_scene_path):
		var go_scene = load(go_scene_path).instantiate()
		get_tree().root.add_child(go_scene)
		if go_scene.has_method("set_reason"):
			go_scene.call_deferred("set_reason", reason)
	get_tree().paused = true

# ─────────────────────────────────────
# CALLBACKS WAVES
# ─────────────────────────────────────
func _on_wave_completed(wave_number: int):
	waves_completed = wave_number
	emit_signal("wave_completed", wave_number)
	print("Wave ", wave_number, " terminée !")

func _on_all_waves_completed():
	if not is_game_over:
		end_game("Victoire ! Vous avez survécu à toutes les vagues !")

# ─────────────────────────────────────
# UI
# ─────────────────────────────────────
func update_ui():
	if not ui_label: return
	
	var current = wave_manager.get_current_wave_number() if wave_manager else 0
	var total = wave_manager.get_total_waves() if wave_manager else 0
	var wave_text = str(current)
	
	if wave_manager and wave_manager.has_method("is_endless") and wave_manager.is_endless():
		ui_label.text = "HP: %d\nOr: %d\nWave: %s" % [player_hp, gold, wave_text]
	else:
		ui_label.text = "HP: %d\nOr: %d\nWave: %s/%d" % [player_hp, gold, current, total]
