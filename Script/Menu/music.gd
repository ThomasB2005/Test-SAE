extends Node

func _ready():
	if not $AudioStreamPlayer.is_playing():
		$AudioStreamPlayer.play()
