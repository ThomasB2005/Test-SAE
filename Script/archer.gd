extends "res://Script/entity.gd"

@onready var archer:AnimatedSprite3D = $AnimatedSprite3D

var can_shoot = true
var shoot_cooldown = 2.0

func _ready():
	animator = archer # Liaison de la variable générique de la classe mère
	maxHealth = 60.0 # Initialisation des PV max
	currentHealth = maxHealth
	
	healthBar.max_value = maxHealth
	healthBar.value = currentHealth
	
	# Détecter aussi les Area3D qui entrent
	detection_area.area_entered.connect(_on_area_entered)
	
	archer.play("idle")
