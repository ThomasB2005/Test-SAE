extends "res://Script/Entity/entity.gd"

@onready var slime: AnimatedSprite3D = $AnimatedSprite3D

func _ready():
	animator = slime # Liaison de la variable générique de la classe mère
	maxHealth = 20 # Initialisation des PV max
	damage = 2
	attack_cd = 2
	team = "enemie"
	type = "melee"

	super._ready()
	
	animator.play("idle")
