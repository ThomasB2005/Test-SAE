# scenes/shop_slot.gd
extends Panel

@onready var icon = $MarginContainer/VBoxContainer/Icon
@onready var title_lbl = $MarginContainer/VBoxContainer/Title
@onready var price_lbl = $MarginContainer/VBoxContainer/Price
@onready var buy_btn = $MarginContainer/VBoxContainer/Buy

var item_data : Resource

func setup_item(data: Resource):
	item_data = data
	icon.texture = data.icon
	title_lbl.text = data.title
	price_lbl.text = str(data.price) + " G"

func _on_buy_btn_pressed():
	var menu = get_tree().current_scene.get_node("Menu_pause")
	if menu.buy_upgrade(item_data):
		buy_btn.disabled = true
		buy_btn.text = "Acheté"
