extends Node3D

@onready var healthBar = $Sprite3D/SubViewport/Panel/HealthBar
@onready var detection_area = $Area3D
@export var maxHealth = 0 
@export var team = "" # Ajouter une équipe ("ally", "enemy", etc.)

var animator: AnimatedSprite3D
var sfx_attck: AudioStreamPlayer
var sfx_hit: AudioStreamPlayer
var currentHealth
var is_alive = true
var damage = 0
var attack_cd = 0
var can_attack = true # Pour gérer le cooldown
var current_target = null # Cible actuelle

func _ready():
	currentHealth = maxHealth
	if healthBar:
		healthBar.max_value = maxHealth
		healthBar.value = currentHealth
	if detection_area:
		detection_area.area_entered.connect(_on_area_entered)
		detection_area.area_exited.connect(_on_area_exited)

func _process(delta):
	# Attaquer la cible si elle existe et qu'on peut attaquer
	if current_target and can_attack and is_alive:
		attack(current_target)

func _on_area_entered(area: Node3D):
	var target = area.get_parent()
	# Vérifier que c'est un ennemi valide
	if target.has_method("take_damage") and target.is_alive and target.team != team:
		print(name, " détecte ", target.name)
		current_target = target

func _on_area_exited(area: Node3D):
	var target = area.get_parent()
	if target == current_target:
		current_target = null
		print(name, " perd la cible")

func attack(target: Node3D):
	if not can_attack or not target.is_alive:
		return
		
	can_attack = false
	animator.play("attack")
	print(name, " attaque ", target.name)
	if sfx_attck:
		await get_tree().create_timer(0.7).timeout
		sfx_attck.play()
		
	await animator.animation_finished
	
	
	# Vérifier que la cible existe encore
	if is_instance_valid(target) and target.is_alive:
		target.take_damage(damage, self)
	
	animator.play("idle")
	
	# Cooldown
	await get_tree().create_timer(attack_cd).timeout
	can_attack = true
	

func take_damage(amount, attacker):
	if not is_alive:
		return
		
	if sfx_hit:
		sfx_hit.play()
	else:
		print("cénul")
	currentHealth -= amount
	healthBar.value = currentHealth
	print(name, " prend ", amount, " dégâts. PV: ", currentHealth)
	
	if currentHealth <= 0:
		die()

func die():
	is_alive = false
	current_target = null
	animator.play("die")
	print(name, " est mort")
	await get_tree().create_timer(4.0).timeout
	queue_free()
