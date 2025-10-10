extends "res://Script/entity.gd"

@onready var slime: AnimatedSprite3D = $AnimatedSprite3D

func _ready():
	
	animator = slime # Liaison de la variable générique de la classe mère
	animator.play("idle")
	maxHealth = 30.0 # Initialisation des PV max
	damage = 5
	attack_cd = 2.0
	team = "enemie"
	
	super._ready()
	
	
	
