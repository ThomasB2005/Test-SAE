# res://Script/turret_shop_slot.gd
extends PanelContainer

signal turret_buy_requested(turret_scene: PackedScene)

var turret_scene: PackedScene = null
var turret_data: Dictionary = {}
var current_gold: int = 0

var icon: TextureRect = null
var name_label: Label = null
var type_label: Label = null
var stats_label: Label = null
var price_label: Label = null
var buy_button: Button = null

func _ready() -> void:
	call_deferred("_setup_nodes")

func _setup_nodes() -> void:
	await get_tree().process_frame
	
	icon = get_node_or_null("VBoxContainer/Icon")
	name_label = get_node_or_null("VBoxContainer/Name")
	type_label = get_node_or_null("VBoxContainer/Type")
	stats_label = get_node_or_null("VBoxContainer/Stats")
	price_label = get_node_or_null("VBoxContainer/Price")
	buy_button = get_node_or_null("VBoxContainer/BuyButton")
	
	if buy_button and not buy_button.pressed.is_connected(_on_buy_pressed):
		buy_button.pressed.connect(_on_buy_pressed)
	
	if not turret_data.is_empty():
		update_display()

func set_turret(scene: PackedScene, gold: int = 0) -> void:
	turret_scene = scene
	current_gold = gold
	
	if not scene:
		return
	
	var temp_turret = scene.instantiate()
	
	turret_data = {
		"name": temp_turret.name if "name" in temp_turret else "Tourelle",
		"cost": temp_turret.cost if "cost" in temp_turret else 10,
		"type": temp_turret.type if "type" in temp_turret else "unknown",
		"damage": temp_turret.damage if "damage" in temp_turret else 0,
		"attack_cd": temp_turret.attack_cd if "attack_cd" in temp_turret else 0,
		"max_health": temp_turret.maxHealth if "maxHealth" in temp_turret else 0
	}
	
	var sprite = temp_turret.get_node_or_null("AnimatedSprite3D")
	if sprite and sprite is AnimatedSprite3D:
		var frames = sprite.sprite_frames
		if frames:
			var frame_texture = frames.get_frame_texture("idle", 0)
			if frame_texture:
				turret_data["icon"] = frame_texture
	
	temp_turret.queue_free()
	
	if name_label != null:
		update_display()
	else:
		await get_tree().create_timer(0.1).timeout
		update_display()

func update_display() -> void:
	if turret_data.is_empty():
		return
	
	if name_label and is_instance_valid(name_label):
		name_label.text = turret_data.get("name", "???")
	
	if type_label and is_instance_valid(type_label):
		var type_text = turret_data.get("type", "unknown")
		match type_text:
			"ranged":
				type_label.text = "🏹 Distance"
			"melee":
				type_label.text = "⚔️ Mêlée"
			_:
				type_label.text = type_text
	
	if stats_label and is_instance_valid(stats_label):
		var dmg = turret_data.get("damage", 0)
		var cd = turret_data.get("attack_cd", 0)
		stats_label.text = "DMG: %d\nCD: %.1fs" % [dmg, cd]
	
	if price_label and is_instance_valid(price_label):
		var cost = turret_data.get("cost", 0)
		price_label.text = "%d G" % cost
		
		if current_gold < cost:
			price_label.add_theme_color_override("font_color", Color.RED)
		else:
			price_label.add_theme_color_override("font_color", Color.GREEN)
	
	if icon and is_instance_valid(icon) and turret_data.has("icon"):
		icon.texture = turret_data["icon"]
	
	if buy_button and is_instance_valid(buy_button):
		var cost = turret_data.get("cost", 0)
		buy_button.disabled = current_gold < cost
		
		if buy_button.disabled:
			buy_button.modulate = Color(0.5, 0.5, 0.5, 1.0)
		else:
			buy_button.modulate = Color(1, 1, 1, 1)

func _on_buy_pressed() -> void:
	if turret_scene:
		turret_buy_requested.emit(turret_scene)
