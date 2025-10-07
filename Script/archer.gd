extends CharacterBody3D

@onready var archer:AnimatedSprite3D = $AnimatedSprite3D
@onready var detection_area = $Area3D  # Le Area3D avec la sphère de collision
@onready var arrow_spawn_point = $ArrowSpawnPoint

@export var arrow_scene: PackedScene

var can_shoot = true
var shoot_cooldown = 2.0

func _ready():
	
	# Connecter le signal body_entered de l'Area3D
	detection_area.body_entered.connect(_on_body_entered)
	
	# Optionnel : détecter aussi les Area3D qui entrent
	detection_area.area_entered.connect(_on_area_entered)
	
	archer.play("idle")

# Détecte les corps physiques (RigidBody3D, CharacterBody3D, StaticBody3D, etc.)
func _on_body_entered(body: Node3D):
	# Tu peux vérifier le type d'objet si besoin
	if body.is_in_group("enemy"):  # Exemple avec un groupe
		shoot_at_target(body)
		
# Détecte les Area3D qui entrent
func _on_area_entered(area: Area3D):
	shoot_at_target(area)

func shoot_at_target(target: Area3D):
	if not can_shoot:
		return
	
	if arrow_scene:
		var arrow = arrow_scene.instantiate()
		get_parent().add_child(arrow)
		
		# Position + rotation + échelle
		arrow.global_transform.origin = arrow_spawn_point.global_transform.origin
		arrow.scale = Vector3.ONE
		
		# Orientation vers la cible (Area3D)
		arrow.look_at(target.global_transform.origin, Vector3.UP)
		
		if arrow is RigidBody3D:
			arrow.linear_velocity = arrow.transform.basis.z * -20  # vitesse 20
		
		# Animation
		archer.play("shooting")
		
		can_shoot = false
		await get_tree().create_timer(shoot_cooldown).timeout
		can_shoot = true
