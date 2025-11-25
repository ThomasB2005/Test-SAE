extends Control

func _ready():
	# Ensure this UI processes while the game is paused
	# 2 corresponds to PROCESS pause mode
	set("pause_mode", 2)
	var restart_btn = get_node_or_null("Panel/VBox/Buttons/RestartButton")
	var menu_btn = get_node_or_null("Panel/VBox/Buttons/MenuButton")
	if restart_btn:
		restart_btn.pressed.connect(Callable(self, "_on_restart_pressed"))
	else:
		print("GameOver UI: Restart button not found")
	if menu_btn:
		menu_btn.pressed.connect(Callable(self, "_on_menu_pressed"))
	else:
		print("GameOver UI: Menu button not found")

func set_reason(text: String) -> void:
	if has_node("Panel/VBox/ReasonLabel"):
		$Panel/VBox/ReasonLabel.text = text

func _on_restart_pressed():
	print("GameOver: Restart pressed")
	get_tree().paused = false
	# Try to reload the current scene; fallback if API differs
	if get_tree().has_method("reload_current_scene"):
		get_tree().reload_current_scene()
	else:
		var current = get_tree().current_scene
		if current and current.filename != "":
			get_tree().change_scene_to_file(current.filename)

func _on_menu_pressed():
	print("GameOver: Menu pressed")
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/Menu/menu.tscn")
