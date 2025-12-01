extends "res://Script/Entity/entity.gd"

@onready var wizard1: AnimatedSprite3D = $AnimatedSprite3D
@onready var attack_1: AudioStreamPlayer = $attack1
@onready var hit: AudioStreamPlayer = $hit

func _ready():
	animator = wizard1 # Liaison de la variable générique de la classe mère
	sfx_attck = attack_1
	sfx_hit = hit
	maxHealth = 30 # Initialisation des PV max
	damage = 2
	attack_cd = 4
	team = "enemie"

	super._ready()
	
	animator.play("idle")
