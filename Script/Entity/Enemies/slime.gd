extends "res://Script/Entity/entity.gd"

@onready var slime: AnimatedSprite3D = $AnimatedSprite3D

func _ready():
	animator = slime # Liaison de la variable générique de la classe mère
	maxHealth = 30.0 # Initialisation des PV max
	damage = 13
	attack_cd = 2.0
	team = "enemie"

	super._ready()
	
	animator.play("idle")
