extends "res://Script/Entity/entity.gd"

@onready var archer: AnimatedSprite3D = $AnimatedSprite3D

func _ready():
	animator = archer
	maxHealth = 40.0
	damage = 12
	attack_cd = 2.0
	team = "ally"
	
	super._ready()
	
	animator.play("idle")
