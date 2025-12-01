extends Control
@onready var settings = preload("res://Scenes/Menu/settings.tscn")
@onready var click: AudioStreamPlayer = $Click


func _on_btn_quit_button_down() -> void:
	click.play()
	await click.finished
	get_tree().quit()

func _on_btn_settings_button_down() -> void:
	click.play()
	await click.finished
	get_tree().change_scene_to_file("res://Scenes/Menu/settings.tscn")
	

func _on_btn_start_button_down() -> void:
	click.play()
	await click.finished
	get_tree().change_scene_to_file("res://Scenes/SandBox/Sandbox.tscn")
