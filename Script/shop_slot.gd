extends Control

@onready var icon       : TextureRect = $Icon
@onready var title_lbl  : Label       = $VBoxContainer/Title
@onready var price_lbl  : Label       = $VBoxContainer/Prix
@onready var buy_btn    : Button      = $VBoxContainer/Acheter

var item : Item : set = _set_item
var current_gold : int = 0 : set = _set_gold

func _set_item(new_item: Item) -> void:
	item = new_item
	if item:
		icon.texture   = item.icon
		title_lbl.text = item.title
		price_lbl.text = str(item.price) + " G"
		buy_btn.text   = "Acheter"
		buy_btn.disabled = false
		
		# Connexion automatique du bouton (plus jamais besoin de le faire à la main)
		if not buy_btn.pressed.is_connected(_on_Acheter_pressed):
			buy_btn.pressed.connect(_on_Acheter_pressed)
		
		_set_gold(current_gold)
	else:
		icon.texture   = null
		title_lbl.text = ""
		price_lbl.text = ""
		buy_btn.text   = ""

func _set_gold(new_gold: int) -> void:
	current_gold = new_gold
	if not item or not price_lbl: return
	
	if current_gold < item.price:
		price_lbl.add_theme_color_override("font_color", Color(1, 0.3, 0.3))
		buy_btn.disabled = true
	else:
		price_lbl.remove_theme_color_override("font_color")
		buy_btn.disabled = false

# Message de confirmation dans la console
func _on_Acheter_pressed() -> void:
	var menu_pause = get_tree().current_scene.get_node("PauseMenu")
	
	if menu_pause and menu_pause.buy_upgrade(item):
		buy_btn.disabled = true
		buy_btn.text = "Acheté !"
		print("ACHAT VALIDÉ ! → ", item.title, " pour ", item.price, " G")
	else:
		print("ACHAT REFUSÉ → ", item.title, " (pas assez d’or ou aucune tourelle sélectionnée)")
