extends Control
@onready var menu = preload("res://Scenes/Menu/menu.tscn")
@onready var click: AudioStreamPlayer = $Click

# Références aux HSliders
@onready var hsl_volume_principal = $vbcButtons/hslVolumePrincipal
@onready var hsl_volume_music = $vbcButtons/hslVolumeMusic
@onready var hsl_volume_sfx = $vbcButtons/hslVolumeSFX

# Références aux bus audio
var master_bus_idx: int
var music_bus_idx: int
var sfx_bus_idx: int

func _ready() -> void:
	# Récupérer les indices des bus audio
	master_bus_idx = AudioServer.get_bus_index("Master")
	music_bus_idx = AudioServer.get_bus_index("Music")
	sfx_bus_idx = AudioServer.get_bus_index("SFX")
	
	# Initialiser les sliders avec les volumes actuels
	hsl_volume_principal.value = db_to_linear(AudioServer.get_bus_volume_db(master_bus_idx))
	hsl_volume_music.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_idx))
	hsl_volume_sfx.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_idx))
	
	# Connecter les signaux des sliders
	hsl_volume_principal.value_changed.connect(_on_volume_principal_changed)
	hsl_volume_music.value_changed.connect(_on_volume_music_changed)
	hsl_volume_sfx.value_changed.connect(_on_volume_sfx_changed)

func _on_volume_principal_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus_idx, linear_to_db(value))

func _on_volume_music_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus_idx, linear_to_db(value))

func _on_volume_sfx_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus_idx, linear_to_db(value))

func _on_btn_back_button_down() -> void:
	click.play()
	await click.finished
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")

func _on_btn_save_button_down() -> void:
	click.play()
	await click.finished
	get_tree().change_scene_to_file("res://Scenes/Menu/menu.tscn")
