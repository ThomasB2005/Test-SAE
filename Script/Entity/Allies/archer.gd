extends "res://Script/turret.gd"

@onready var archer: AnimatedSprite3D = $AnimatedSprite3D
@onready var throw_1: AudioStreamPlayer = $throw1
@onready var hit: AudioStreamPlayer = $hit

func _ready():
	animator = archer
	sfx_attck = throw_1
	sfx_hit = hit
	maxHealth = 40
	damage = 30
	attack_cd = 1
	team = "ally"
	cost = 5
	type = "ranged"
	
	super._ready()
	
	animator.play("idle")
