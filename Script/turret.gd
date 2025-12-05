# res://Script/turret.gd
extends "res://Script/entity.gd"

# ────── SÉLECTION VISUELLE ET CLIC ──────
@onready var selection_ring = $SelectionRing   # ← Ajoute ce nœud dans la scène (voir plus bas)
var is_selected : bool = false

func _ready() -> void:
	super._ready()  # garde tout le _ready() de entity.gd
	
	# On crée une Area2D + collision si elle n'existe pas déjà
	if not has_node("ClickArea"):
		var area = Area2D.new()
		area.name = "ClickArea"
		add_child(area)
		
		var collision = CollisionShape2D.new()
		area.add_child(collision)
		var shape = CircleShape2D.new()
		shape.radius = 40  # ajuste selon la taille de ta tourelle
		collision.shape = shape
		
		# Connexion des signaux
		area.mouse_entered.connect(_on_mouse_entered)
		area.mouse_exited.connect(_on_mouse_exited)
		area.input_event.connect(_on_input_event)
	
	# Cache le cercle au début
	if selection_ring:
		selection_ring.visible = false

func _on_mouse_entered() -> void:
	if selection_ring and not is_selected:
		selection_ring.visible = true
		selection_ring.modulate = Color(0, 1, 1, 0.5)  # cyan au survol

func _on_mouse_exited() -> void:
	if selection_ring and not is_selected:
		selection_ring.visible = false

func _on_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		GameManager.selected_turret = self
		is_selected = true
		_update_selection_ring()
		print("TOURELLE SÉLECTIONNÉE → ", name)

func _update_selection_ring() -> void:
	if selection_ring:
		selection_ring.visible = true
		selection_ring.modulate = Color(0, 1, 0, 0.8)  # vert fixe

# Optionnel : désélectionner en cliquant ailleurs (à mettre dans ton niveau principal)
# func _unhandled_input(event):
#     if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#         if GameManager.selected_turret and GameManager.selected_turret != self:
#             GameManager.selected_turret.is_selected = false
#             GameManager.selected_turret._update_selection_ring()
#             GameManager.selected_turret = null
