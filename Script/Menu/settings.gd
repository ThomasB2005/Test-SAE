extends Control
@onready var menu = preload("res://Scenes/Menu/menu.tscn")
@onready var click: AudioStreamPlayer = $Click

func _on_btn_back_button_down() -> void:
	click.play()
	await click.finished
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")
