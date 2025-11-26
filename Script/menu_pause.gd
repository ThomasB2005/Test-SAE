# menu_pause.gd
extends Control

@onready var Boutique = $Boutique
@onready var GridContai = $Boutique/GridContai

@export var upgrade_items : Array[Resource] = []  # ← ON UTILISE Resource, pas Item → PLUS D’ERREUR
@export var shop_slot_scene : PackedScene = preload("res://scenes/shop_slot.tscn")

var gold : int = 5000
var paused : bool = false

func _ready():
	hide()
	Boutique.hide()
	$VBoxContainer/Label.text = "Or : 5000"  # ← Ton Label d’or (tu l’as déjà)
	load_shop()

func _process(_delta):
	if Input.is_action_just_pressed("esc"):
		if paused:
			resume()
		else:
			pause()

func pause():
	get_tree().paused = true
	paused = true
	show()
	Boutique.show()

func resume():
	get_tree().paused = false
	paused = false
	hide()
	Boutique.hide()

func load_shop():
	for child in GridContai.get_children():
		child.queue_free()
	
	for item in upgrade_items:
		var slot = shop_slot_scene.instantiate()
		GridContai.add_child(slot)
		slot.setup_item(item)  # ← Fonction qu’on va créer dans shop_slot

func buy_upgrade(item_resource):
	if not GameManager.selected_turret:
		print("Aucune tourelle sélectionnée !")
		return false
	if gold < item_resource.price:
		print("Pas assez d'or !")
		return false
	
	gold -= item_resource.price
	$VBoxContainer/Label.text = "Or : " + str(gold)
	
	# Applique la stratégie à la tourelle sélectionnée
	GameManager.selected_turret.add_strategy(item_resource.strategy)
	print(item_resource.title + " appliqué !")
	return true

# BOUTONS
func _on_continuer_pressed(): resume()
func _on_quitter_pressed(): get_tree().quit()
func _on_boutique_pressed(): Boutique.visible = !Boutique.visible
