extends "res://Script/entity.gd"


@onready var archer: AnimatedSprite3D = $AnimatedSprite3D

func _ready():
	animator = archer
	maxHealth = 60.0
	damage = 15
	attack_cd = 2.0
	team = "ally" # Définir l'équipe

	
	super._ready()
	
	animator.play("idle")
