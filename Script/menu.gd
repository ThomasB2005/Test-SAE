extends Control
@onready var settings_scene = preload("res://Scenes/Menu/settings.tscn")

# Temporaire 
@onready var map_scene = preload("res://Scenes/Maps/map1.tscn")


func _on_btn_settings_button_down() -> void:
	get_tree().change_scene_to_packed(settings_scene)



func _on_btn_quit_button_down() -> void:
	get_tree().quit()


func _on_btn_start_button_down() -> void:
	get_tree().change_scene_to_packed(map_scene)
