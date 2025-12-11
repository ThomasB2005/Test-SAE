# res://Script/TurretPlacementManager.gd
extends Node3D

signal placement_started(turret_scene: PackedScene)
signal placement_cancelled()
signal turret_placed(turret: Node3D, position: Vector3)

@export var valid_placement_color := Color(0, 1, 0, 0.5)
@export var invalid_placement_color := Color(1, 0, 0, 0.5)

var is_placing := false
var current_turret_scene: PackedScene = null
var preview_turret: Node3D = null
var placement_indicator: MeshInstance3D = null
var camera: Camera3D = null
var gridmap: GridMap = null
var valid_placement := false

func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	#gridmap = get_node_or_null("../GridMap")  # ← Adapter si ton GridMap n'est pas au même niveau
	if not camera:
		push_error("Caméra introuvable!")
	#if not gridmap:
	#	push_error("GridMap introuvable! Vérifie le chemin.")
	create_placement_indicator()

func create_placement_indicator() -> void:
	placement_indicator = MeshInstance3D.new()
	var cylinder = CylinderMesh.new()
	cylinder.top_radius = 0.5
	cylinder.bottom_radius = 0.5
	cylinder.height = 0.05
	placement_indicator.mesh = cylinder
	var mat = StandardMaterial3D.new()
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.albedo_color = valid_placement_color
	mat.flags_unshaded = true
	placement_indicator.material_override = mat
	add_child(placement_indicator)
	placement_indicator.visible = false

func start_placement(turret_scene: PackedScene) -> void:
	if not turret_scene: return
	is_placing = true
	current_turret_scene = turret_scene

	preview_turret = turret_scene.instantiate()
	add_child(preview_turret)

	# Désactive TOUT ce qui rend le preview "vivant"
	preview_turret.set_process(false)
	preview_turret.set_physics_process(false)
	preview_turret.is_alive = false
	if preview_turret.has_node("AttackBox"):
		preview_turret.get_node("AttackBox").monitoring = false
		preview_turret.get_node("AttackBox").monitorable = false
	if preview_turret.has_node("HitBox"):
		preview_turret.get_node("HitBox").monitoring = false
		preview_turret.get_node("HitBox").monitorable = false

	make_preview_transparent(preview_turret)
	placement_indicator.visible = true
	placement_started.emit(turret_scene)

func make_preview_transparent(node: Node) -> void:
	# Version corrigée pour AnimatedSprite3D + MeshInstance3D
	if node is AnimatedSprite3D:
		node.modulate.a = 0.4
	elif node is Sprite3D:
		node.modulate.a = 0.4
	elif node is MeshInstance3D:
		var mat = node.get_surface_override_material(0)
		if not mat:
			mat = StandardMaterial3D.new()
			node.set_surface_override_material(0, mat)
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
		mat.albedo_color.a = 0.4
		mat.flags_unshaded = true  # pour que ça reste visible même dans l'ombre
	
	# On applique à tous les enfants aussi
	for child in node.get_children():
		make_preview_transparent(child)

func _process(_delta: float) -> void:
	if not is_placing or not camera or not preview_turret: return

	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 100

	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
	if result.is_empty(): return

	var world_pos = result.position
	var snapped_pos = Vector3(round(world_pos.x), 0.5, round(world_pos.z))

	preview_turret.global_position = snapped_pos
	placement_indicator.global_position = snapped_pos + Vector3(0, -0.45, 0)

	valid_placement = is_valid_placement(snapped_pos)
	placement_indicator.material_override.albedo_color = valid_placement_color if valid_placement else invalid_placement_color

func is_valid_placement(position: Vector3) -> bool:
	# ON AUTORISE LE PLACEMENT PARTOUT SAUF :
	# 1. Sur le chemin des ennemis (on garde le blocage chemin)
	# 2. Sur une autre tourelle
	
	# 1. Blocage du chemin ennemi (garde ces lignes)
	if _is_on_enemy_path(position):
		return false
	
	# 2. Blocage si une tourelle est déjà trop proche
	for turret in get_tree().get_nodes_in_group("turrets"):
		if turret.global_position.distance_to(position) < 1.0:
			return false
	
	# TOUT LE RESTE EST AUTORISÉ → plus besoin de GridMap
	return true

# Tu peux garder ou supprimer cette fonction selon ta map
func _is_on_enemy_path(pos: Vector3) -> bool:
	var blocked = [
		Vector3(7,0.5,2), Vector3(6,0.5,2), Vector3(5,0.5,2), Vector3(4,0.5,2),
		Vector3(4,0.5,1), Vector3(4,0.5,0), Vector3(3,0.5,0), Vector3(2,0.5,0),
		Vector3(1,0.5,0), Vector3(0,0.5,0), Vector3(0,0.5,1)
	]
	for b in blocked:
		if pos.distance_to(b) < 0.6:
			return true
	return false

func _input(event: InputEvent) -> void:
	if not is_placing: return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if valid_placement:
			place_turret()

	if event.is_action_pressed("ui_cancel") or (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed):
		cancel_placement()

func place_turret() -> void:
	if not valid_placement or not current_turret_scene: return

	var pos = preview_turret.global_position
	var cost = _get_turret_cost(current_turret_scene)

	if GameManager and not GameManager.spend_gold(cost):
		print("Pas assez d'or !")
		return

	var new_turret = current_turret_scene.instantiate()
	get_parent().add_child(new_turret)
	new_turret.global_position = pos
	new_turret.add_to_group("turrets")

	# Réactive tout
	new_turret.set_process(true)
	new_turret.set_physics_process(true)
	new_turret.is_alive = true
	if new_turret.has_node("AttackBox"):
		new_turret.get_node("AttackBox").monitoring = true
		new_turret.get_node("AttackBox").monitorable = true
	if new_turret.has_node("HitBox"):
		new_turret.get_node("HitBox").monitoring = true
		new_turret.get_node("HitBox").monitorable = true

	turret_placed.emit(new_turret, pos)
	cancel_placement()

func _get_turret_cost(scene: PackedScene) -> int:
	var temp = scene.instantiate()
	var c = temp.cost if "cost" in temp else 50
	temp.queue_free()
	return c

func cancel_placement() -> void:
	is_placing = false
	current_turret_scene = null
	if is_instance_valid(preview_turret):
		preview_turret.queue_free()
		preview_turret = null
	placement_indicator.visible = false
	placement_cancelled.emit()
