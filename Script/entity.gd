extends Node3D

@onready var healthBar = $Sprite3D/SubViewport/Panel/HealthBar
@onready var detection_area = $Area3D  # Le Area3D avec le cube de collision

@export var maxHealth: float = 0 
var currentHealth: float
var is_alive = true

func _ready():
	currentHealth = maxHealth
	if healthBar:
		healthBar.max_value = maxHealth
		healthBar.value = currentHealth

func attack(entity, attack_cd):
	entity.play("attack")
	await entity.animation_finished
	entity.play("idle")
	await get_tree().create_timer(attack_cd).timeout
	
	# TODO Système de dégâts

# TODO retirer le "1" du nom de la fonction 
func take_damage1(damage: float, entity):
	healthBar.value -= damage
	print("-----------J'AI ", healthBar.value, " HP -------------") # debug
	if healthBar.value <= 0:
		die(entity)
		
func die(entity):
	is_alive = false
	entity.play("die")
	await get_tree().create_timer(4.0).timeout
	queue_free()
