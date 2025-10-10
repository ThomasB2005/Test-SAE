extends Node3D

@onready var healthBar = $Sprite3D/SubViewport/Panel/HealthBar
@onready var detection_area = $Area3D  # Le Area3D avec le cube de collision

@export var maxHealth: float = 0 
var currentHealth: float

func _ready():
	currentHealth = maxHealth
	if healthBar:
		healthBar.max_value = maxHealth
		healthBar.value = currentHealth
