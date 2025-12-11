# res://Script/turret.gd
extends "res://Script/Entity/entity.gd"

var is_selected: bool = false
var selection_indicator: MeshInstance3D = null
var clickable_body: StaticBody3D = null

func _ready() -> void:
	super._ready()
	create_selection_indicator()
	create_clickable_body()

func create_selection_indicator() -> void:
	selection_indicator = MeshInstance3D.new()
	var ring = CylinderMesh.new()
	ring.top_radius = 0.7
	ring.bottom_radius = 0.7
	ring.height = 0.05
	selection_indicator.mesh = ring
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0,1,0,0.6)
	mat.emission_enabled = true
	mat.emission = Color(0,1,0)
	mat.emission_energy = 3.0
	mat.flags_unshaded = true
	selection_indicator.material_override = mat
	add_child(selection_indicator)
	selection_indicator.position.y = 0.02
	selection_indicator.visible = false

func create_clickable_body() -> void:
	clickable_body = StaticBody3D.new()
	clickable_body.name = "ClickableBody"
	clickable_body.input_ray_pickable = true
	clickable_body.collision_layer = 1        # ← Layer 1 (pickable par défaut)
	clickable_body.collision_mask = 0

	var col = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = Vector3(2, 2, 2)              # ← Plus grand pour être sûr d'être cliqué
	col.shape = shape
	col.position.y = 0.6
	clickable_body.add_child(col)
	add_child(clickable_body)

	clickable_body.input_event.connect(_on_input_event)

func _on_input_event(_camera, event, _pos, _normal, _shape):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if GameManager:
			GameManager.select_turret(self)

func select() -> void:
	is_selected = true
	selection_indicator.visible = true

func deselect() -> void:
	is_selected = false
	selection_indicator.visible = false

func apply_upgrade(item: Item) -> void:
	if item.strategy and item.strategy.has_method("apply_to_turret"):
		item.strategy.apply_to_turret(self)
