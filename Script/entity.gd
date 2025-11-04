extends Node3D

@onready var healthBar = $Sprite3D/SubViewport/Panel/HealthBar
@onready var detection_area = $Area3D  # Le Area3D avec le cube de collision

@export var maxHealth = 0 
var animator: AnimatedSprite3D
var currentHealth
var is_alive = true
var damage = 0
var attack_cd = 0

func _ready():
	currentHealth = maxHealth
	if healthBar:
		healthBar.max_value = maxHealth
		healthBar.value = currentHealth

	if detection_area:
		# Détecter aussi les Area3D qui entrent
		detection_area.area_entered.connect(_on_area_entered)

# Détecte les Area3D qui entrent
func _on_area_entered(area: Node3D):
	if area.has_method("take_damage"):
		attack(area)

# L'entité attaque la cible
func attack(target: Node3D):
	animator.play("attack") # Jouer l'animation d'attaque
	await animator.animation_finished
	animator.play("idle") # Jouer l'animation d'inactivité
	target.take_damage(damage, self)
	await get_tree().create_timer(attack_cd).timeout

func take_damage(damage, animator):
	healthBar.value -= damage # L'entité prend des dégâts
	if healthBar.value <= 0:
		die() # l'entité meurt

func die():
	is_alive = false
	animator.play("die") # Jouer l'animation de mort
	await get_tree().create_timer(4.0).timeout
	queue_free() # Supprimer l'entité de la scène
