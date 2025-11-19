extends Control

var paused := false

func resume():
	get_tree().paused = false
	paused = false

func pause():
	get_tree().paused = true
	paused = true

func testEsc():
	if Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()
	elif Input.is_action_just_pressed("esc") and !get_tree().paused:
		pause()




func _process(delta):
	testEsc()

func _on_continuer_pressed() -> void:
	resume()

func _on_boutique_pressed() -> void:
	pass # Replace with function body.

func _on_quitter_pressed() -> void:
	pass # Replace with function body.
