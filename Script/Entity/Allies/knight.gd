extends "res://Script/Entity/entity.gd"

@onready var knight: AnimatedSprite3D = $AnimatedSprite3D

func _ready():
	animator = knight
	maxHealth = 80.0
	damage = 20
	attack_cd = 4.0
	team = "ally"
	
	super._ready()
	
	animator.play("idle")
