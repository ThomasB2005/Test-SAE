# res://Script/menu_pause.gd
extends Control

@export var upgrade_items : Array[Item] = []
@export var shop_slot_scene : PackedScene
@export var turret_scenes : Array[PackedScene] = []
@export var turret_slot_scene : PackedScene

var placement_manager: Node3D = null

func _ready() -> void:
	visible = false
	$Menupause.hide()
	$PanelTurret.hide()
	$PanelUpgrade.hide()
	
	placement_manager = get_node_or_null("/root/Node3D/TurretPlacementManager")
	if not placement_manager:
		push_error("❌ TurretPlacementManager introuvable!")
	else:
		placement_manager.placement_started.connect(_on_placement_started)
		placement_manager.turret_placed.connect(_on_turret_placed)
	
	if GameManager:
		GameManager.gold_changed.connect(_on_gold_changed)

func _input(event : InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if placement_manager and placement_manager.is_placing:
			return
		
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
		if get_tree().paused:
			$Menupause.show()
			$PanelTurret.hide()
			$PanelUpgrade.hide()
		else:
			$Menupause.hide()
			$PanelTurret.hide()
			$PanelUpgrade.hide()

func _on_continuer_pressed() -> void:
	get_tree().paused = false
	visible = false
	$Menupause.hide()
	$PanelTurret.hide()
	$PanelUpgrade.hide()

func _on_turret_pressed() -> void:
	$Menupause.hide()
	$PanelTurret.show()
	$PanelUpgrade.hide()
	load_turret_shop()

func _on_upgrade_pressed() -> void:
	if not GameManager or not GameManager.selected_turret:
		print("⚠️ Sélectionnez d'abord une tourelle avant d'ouvrir les améliorations!")
		return
	
	$Menupause.hide()
	$PanelTurret.hide()
	$PanelUpgrade.show()
	load_upgrade_shop()

func _on_quitter_pressed() -> void:
	get_tree().quit()

func _on_retour_turret_pressed() -> void:
	$PanelTurret.hide()
	$Menupause.show()

func _on_retour_upgrade_pressed() -> void:
	$PanelUpgrade.hide()
	$Menupause.show()

func load_turret_shop() -> void:
	if turret_scenes.is_empty():
		push_error("❌ Aucune tourelle configurée dans turret_scenes!")
		return
	
	if not turret_slot_scene:
		push_error("❌ turret_slot_scene n'est pas assigné!")
		return
	
	for child in $PanelTurret/GridContainer.get_children():
		child.queue_free()
	
	var gold = 0
	if GameManager:
		gold = GameManager.gold
	
	for turret_scene in turret_scenes:
		var slot = turret_slot_scene.instantiate()
		$PanelTurret/GridContainer.add_child(slot)
		
		slot.set_turret(turret_scene, gold)
		slot.turret_buy_requested.connect(_on_turret_buy_pressed)
	
	print("📦 Boutique de tourelles chargée (%d tourelles)" % turret_scenes.size())

func _on_turret_buy_pressed(turret_scene: PackedScene) -> void:
	if not placement_manager:
		push_error("❌ Placement manager introuvable!")
		return
	
	get_tree().paused = false
	visible = false
	$Menupause.hide()
	$PanelTurret.hide()
	$PanelUpgrade.hide()
	
	placement_manager.start_placement(turret_scene)

func _on_placement_started(_turret_scene: PackedScene) -> void:
	print("🎯 Mode placement activé - Clic gauche pour placer, Clic droit pour annuler")

func _on_turret_placed(turret: Node3D, position: Vector3) -> void:
	print("✅ Tourelle placée:", turret.name, "à", position)

func load_upgrade_shop() -> void:
	if not shop_slot_scene:
		push_error("shop_slot_scene n'est pas assigné !")
		return
	
	for child in $PanelUpgrade/GridContainer.get_children():
		child.queue_free()
	
	for item in upgrade_items:
		var slot = shop_slot_scene.instantiate()
		$PanelUpgrade/GridContainer.add_child(slot)
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
	
	if GameManager.selected_turret.has_method("apply_upgrade"):
		GameManager.selected_turret.apply_upgrade(item)
	
	load_upgrade_shop()
	print("✅ Amélioration achetée: ", item.title)
	return true

func _on_gold_changed(_new_amount: int) -> void:
	if $PanelUpgrade.visible:
		load_upgrade_shop()
	elif $PanelTurret.visible:
		load_turret_shop()
