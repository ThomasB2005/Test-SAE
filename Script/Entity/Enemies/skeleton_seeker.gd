extends "res://Script/Entity/entity.gd"

@onready var skeleton_seeker: AnimatedSprite3D = $AnimatedSprite3D
@onready var attack_1: AudioStreamPlayer = $attack1
@onready var hit: AudioStreamPlayer = $hit

func _ready():
	animator = skeleton_seeker # Liaison de la variable générique de la classe mère
	sfx_attck = attack_1
	sfx_hit = hit
	maxHealth = 400 # Initialisation des PV max
	damage = 2
	attack_cd = 4
	team = "enemie"
	is_boss = true

	super._ready()
	
	animator.play("idle")
