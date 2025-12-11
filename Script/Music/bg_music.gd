extends AudioStreamPlayer

# Liste des noms de scènes où la musique doit jouer (racine des scènes)
var allowed_scenes = ["Menu", "Settings"]
var last_scene = null

func _ready():
	autoplay = false
	last_scene = get_tree().get_current_scene()
	_update_playback()

func _process(_delta):
	var cs = get_tree().get_current_scene()
	if cs != last_scene:
		last_scene = cs
		_update_playback()

func _update_playback():
	var cs = get_tree().get_current_scene()
	if cs and cs.name in allowed_scenes:
		if not is_playing():
			play()
	else:
		if is_playing():
			stop()
