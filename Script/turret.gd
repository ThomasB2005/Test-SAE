extends "res://Script/Entity/entity.gd"

# Système de sélection
var is_selected: bool = false
var selection_indicator: MeshInstance3D
var clickable_body: StaticBody3D

func _ready() -> void:
	super._ready()
	
	# Créer l'indicateur de sélection
	create_selection_indicator()
	
	# Créer la zone cliquable avec StaticBody3D (plus fiable)
	create_clickable_body()

func create_selection_indicator() -> void:
	# Créer un anneau visuel pour montrer la sélection
	selection_indicator = MeshInstance3D.new()
	var cylinder = CylinderMesh.new()
	cylinder.top_radius = 0.6
	cylinder.bottom_radius = 0.6
	cylinder.height = 0.05
	selection_indicator.mesh = cylinder
	
	# Matériau lumineux pour l'anneau
	var material = StandardMaterial3D.new()
	material.albedo_color = Color(0, 1, 0, 0.5)  # Vert semi-transparent
	material.emission_enabled = true
	material.emission = Color(0, 1, 0)
	material.emission_energy = 2.0
	selection_indicator.material_override = material
	
	add_child(selection_indicator)
	selection_indicator.position.y = 0.1
	selection_indicator.visible = false

func create_clickable_body() -> void:
	# StaticBody3D est plus fiable pour les input_event
	clickable_body = StaticBody3D.new()
	clickable_body.name = "ClickableBody"
	
	# Configurer pour recevoir les inputs
	clickable_body.input_ray_pickable = true
	
	# Configurer les layers (layer 32 pour éviter conflits)
	clickable_body.collision_layer = 1 << 31  # Layer 32
	clickable_body.collision_mask = 0
	
	var collision = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = Vector3(1, 1.5, 1)
	collision.shape = shape
	collision.position.y = 0.5  # Centrer la collision sur la tourelle
	
	clickable_body.add_child(collision)
	add_child(clickable_body)
	
	# Connecter le signal
	clickable_body.input_event.connect(_on_body_input_event)
	
	print("✅ StaticBody cliquable créé pour ", name)

func _on_body_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("✅ Clic détecté sur tourelle: ", name)
		if GameManager:
			GameManager.select_turret(self)
		else:
			push_error("GameManager introuvable!")

func select() -> void:
	is_selected = true
	if selection_indicator:
		selection_indicator.visible = true
	print("✨ Tourelle sélectionnée: ", name)

func deselect() -> void:
	is_selected = false
	if selection_indicator:
		selection_indicator.visible = false
	print("⬛ Tourelle désélectionnée: ", name)

# Méthode pour appliquer une amélioration
func apply_upgrade(item: Item) -> void:
	if item.strategy:
		if item.strategy.has_method("apply_to_turret"):
			item.strategy.apply_to_turret(self)
		print(name, " amélioré avec ", item.title)
