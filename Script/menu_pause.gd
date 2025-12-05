extends Control

@export var upgrade_items : Array[Item] = []
@export var shop_slot_scene : PackedScene   # Glisse shop_slot.tscn ici !

var gold : int = 5000

func _ready() -> void:
	visible = false
	$Menupause.hide()
	$Boutique.hide()

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
		if get_tree().paused:
			$Menupause.show()
			$Boutique.hide()
			load_shop()
		else:
			$Menupause.hide()
			$Boutique.hide()

# FONCTIONS EN MINUSCULES → marchent même si tes boutons sont en minuscules
func _on_continuer_pressed() -> void:
	get_tree().paused = false
	visible = false
	$Menupause.hide()
	$Boutique.hide()

func _on_boutique_pressed() -> void:
	$Menupause.hide()
	$Boutique.show()
	load_shop()

func _on_quitter_pressed() -> void:
	get_tree().quit()

func _on_retour_pressed() -> void:
	$Boutique.hide()
	$Menupause.show()

func load_shop() -> void:
	if not shop_slot_scene:
		push_error("shop_slot_scene n'est pas assigné !")
		return
	for child in $Boutique/GridContainer.get_children():
		child.queue_free()
	for item in upgrade_items:
		var slot = shop_slot_scene.instantiate()
		$Boutique/GridContainer.add_child(slot)
		slot.item = item
		slot.current_gold = gold

func buy_upgrade(item: Item) -> bool:
	if not GameManager.selected_turret or gold < item.price:
		return false
	gold -= item.price
	load_shop()
	return true
