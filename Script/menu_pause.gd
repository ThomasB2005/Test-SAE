extends Control

@export var upgrade_items : Array[Item] = []
@export var shop_slot_scene : PackedScene

func _ready() -> void:
	visible = false
	$Menupause.hide()
	$Boutique.hide()
	
	# Connecter les signaux du GameManager (autoload)
	if GameManager:
		GameManager.gold_changed.connect(_on_gold_changed)

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
		if get_tree().paused:
			$Menupause.show()
			$Boutique.hide()
		else:
			$Menupause.hide()
			$Boutique.hide()

func _on_continuer_pressed() -> void:
	get_tree().paused = false
	visible = false
	$Menupause.hide()
	$Boutique.hide()

func _on_boutique_pressed() -> void:
	if not GameManager or not GameManager.selected_turret:
		print("⚠️ Sélectionnez d'abord une tourelle avant d'ouvrir la boutique!")
		# TODO: Afficher un message à l'écran
		return
	
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
	
	# Nettoyer les anciens slots
	for child in $Boutique/GridContainer.get_children():
		child.queue_free()
	
	# Créer les nouveaux slots
	for item in upgrade_items:
		var slot = shop_slot_scene.instantiate()
		$Boutique/GridContainer.add_child(slot)
		slot.item = item
		if GameManager:
			slot.current_gold = GameManager.gold

func buy_upgrade(item: Item) -> bool:
	if not GameManager:
		print("❌ GameManager introuvable!")
		return false
	
	if not GameManager.selected_turret:
		print("❌ Aucune tourelle sélectionnée!")
		return false
	
	if not GameManager.spend_gold(item.price):
		print("❌ Pas assez d'or! (Besoin: %d G, Disponible: %d G)" % [item.price, GameManager.gold])
		return false
	
	# Appliquer l'amélioration à la tourelle sélectionnée
	if GameManager.selected_turret.has_method("apply_upgrade"):
		GameManager.selected_turret.apply_upgrade(item)
	
	load_shop()
	print("✅ Amélioration achetée: ", item.title)
	return true

func _on_gold_changed(_new_amount: int) -> void:
	# Recharger la boutique pour mettre à jour les prix
	if $Boutique.visible:
		load_shop()
