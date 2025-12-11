extends Node3D

@onready var healthBar = get_node_or_null("Sprite3D/SubViewport/Panel/HealthBar")
@onready var BossHealthBar: TextureProgressBar = get_node_or_null("HealthBar/CanvasLayer/TextureProgressBar")
@onready var detection_area = get_node_or_null("AttackBox")
@export var maxHealth = 0 
@export var team = "" # Ajouter une équipe ("ally", "enemy")
@export var type = ""

var animator: AnimatedSprite3D
var sfx_attck: AudioStreamPlayer
var sfx_hit: AudioStreamPlayer
var sfx_death: AudioStreamPlayer
var sfx_spawn: AudioStreamPlayer
var sfx_felled: AudioStreamPlayer
var music: AudioStreamPlayer
var currentHealth
var is_alive = true
var damage = 0
var attack_cd = 0
var cost = 0
var reward = 0
var score = 0
var is_boss = false
var can_attack = true # Pour gérer le cooldown
var current_target = null # Cible actuelle
var facing_right = true # Orientation actuelle de l'entité
@export var targets: Array = [] # Liste des cibles présentes dans la zone

func _ready():
	if is_boss and sfx_spawn:
		sfx_spawn.play()
	if is_boss and music:
		music.play()
	currentHealth = maxHealth
	if healthBar:
		healthBar.max_value = maxHealth
		healthBar.value = currentHealth
	if BossHealthBar:
		BossHealthBar.max_value = maxHealth
		BossHealthBar.value = currentHealth
	if detection_area:
		# Configure collision layers pour être sûr que la détection fonctionne
		detection_area.collision_layer = 1
		detection_area.collision_mask = 1
		detection_area.monitoring = true
		detection_area.monitorable = true
		
		detection_area.area_entered.connect(_on_area_entered)
		detection_area.area_exited.connect(_on_area_exited)

func _process(delta):
	# Attaquer la cible si elle existe et qu'on peut attaquer
	if current_target and can_attack and is_alive:
		attack(current_target)

func _on_area_entered(area: Node3D):
	# Vérifier que la zone détectée est une HitBox ou UnitHitBox (pas une AttackBox)
	if area.name != "HitBox" and area.name != "UnitHitBox":
		return
	
	var target = area.get_parent()
	# Vérifier que c'est un ennemi valide
	if target.has_method("take_damage") and target.is_alive and target.team != team:
		if not targets.has(target):
			targets.append(target)
		# Si on n'a pas de cible actuelle valide, en choisir une
		if not is_instance_valid(current_target) or not current_target or not current_target.is_alive:
			current_target = choose_target()

func _on_area_exited(area: Node3D):
	var target = area.get_parent()
	# Retirer la cible de la liste
	if targets.has(target):
		targets.erase(target)
	# Si c'était la cible actuelle, en choisir une autre
	if target == current_target:
		current_target = choose_target()

func face_target(target: Node3D):
	# Déterminer la direction vers la cible
	var direction_to_target = target.global_position - global_position
	
	# Déterminer si la cible est à gauche ou à droite
	var should_face_right = direction_to_target.x > 0
	
	# Si l'orientation doit changer
	if should_face_right != facing_right:
		facing_right = should_face_right
		# Utiliser flip_h pour inverser le sprite
		animator.flip_h = not facing_right

func choose_target() -> Node3D:
	# Retourne la première cible valide et vivante dans la zone, sinon null
	for t in targets:
		if is_instance_valid(t) and t.is_alive:
			return t
	return null

func set_target_from_collision(unit: Node3D):
	# Appelé par enemy_path_follower quand l'ennemi est bloqué par un warrior
	if unit and unit.has_method("take_damage") and unit.get("is_alive") and unit.is_alive and unit.get("team") and unit.team != team:
		if not targets.has(unit):
			targets.append(unit)
		if not current_target or not is_instance_valid(current_target) or not current_target.is_alive:
			current_target = unit

func attack(target: Node3D):
	if not can_attack or not target.is_alive:
		return
	
	# Se tourner vers la cible avant d'attaquer
	face_target(target)
	
	can_attack = false
	if animator:
		animator.play("attack")
	if sfx_attck:
		await get_tree().create_timer(0.7).timeout
		sfx_attck.play()
		
	if animator:
		await animator.animation_finished
	
	
	# Vérifier que la cible existe encore
	if is_instance_valid(target) and target.is_alive:
		target.take_damage(damage, self)
	# Si la cible est morte après l'attaque ou n'est plus valide, la retirer et en choisir une autre
	if not (is_instance_valid(target) and target.is_alive):
		if targets.has(target):
			targets.erase(target)
		current_target = choose_target()
	
	# Play idle during cooldown
	if animator:
		animator.play("idle")
	
	# Cooldown
	await get_tree().create_timer(attack_cd).timeout
	can_attack = true
	

func take_damage(amount, _attacker):
	if not is_alive:
		return
		
	if sfx_hit:
		sfx_hit.play()
	else:
		print("cénul")
	if is_boss != true:
		currentHealth -= amount
		if healthBar:
			healthBar.value = currentHealth
	else:
		currentHealth -= amount
		if BossHealthBar:
			BossHealthBar.value = currentHealth
		
	print(name, " prend ", amount, " dégâts. PV: ", currentHealth)
	
	if currentHealth <= 0:
		die()

func die():
	is_alive = false
	current_target = null
	if animator:
		animator.play("die")
	if is_boss:
		sfx_felled.play()
		if music:
			music.stop()
	if sfx_death:
		sfx_death.play()
	print(name, " est mort")
	if is_boss != true:
		await get_tree().create_timer(2.0).timeout
	else: 
		await get_tree().create_timer(8.0).timeout
	queue_free()
