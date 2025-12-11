extends Control
@onready var click: AudioStreamPlayer = $Click

func _ready():
	for i in range(1, 26):
		var btn = $GridContainer.get_node("btnMap%s" % i)
		if btn:
			btn.pressed.connect(_on_map_button_pressed.bind(i))

func _on_map_button_pressed(map_number: int) -> void:
	click.play()
	await click.finished
	get_tree().change_scene_to_file("res://Scenes/Maps/map%s.tscn" % map_number)
	
func _on_btn_back_pressed() -> void:
	click.play()
	await click.finished
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")
