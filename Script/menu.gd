extends Control
@onready var settings = preload("res://Menu/settings.tscn")

func _on_btn_start_button_down() -> void:
	get_tree().change_scene_to_file("res://Main/main.tscn")
	
	
func _on_btn_settings_button_down() -> void:
	get_tree().change_scene_to_file("res://Menu/settings.tscn")


func _on_btn_quit_button_down() -> void:
	get_tree().quit()
