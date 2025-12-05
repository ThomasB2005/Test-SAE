extends "res://Script/Entity/entity.gd"

@onready var bringer_of_death: AnimatedSprite3D = $AnimatedSprite3D
@onready var attack_1: AudioStreamPlayer = $attack1
@onready var hit: AudioStreamPlayer = $hit

func _ready():
	animator = bringer_of_death # Liaison de la variable générique de la classe mère
	sfx_attck = attack_1
	sfx_hit = hit
	maxHealth = 100 # Initialisation des PV max
	damage = 15
	attack_cd = 3
	team = "enemie"
	is_boss = true

	super._ready()
	
	animator.play("idle")
