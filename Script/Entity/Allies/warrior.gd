extends "res://Script/turret.gd"

@onready var warrior: AnimatedSprite3D = $AnimatedSprite3D
@onready var swip_1: AudioStreamPlayer = $swip1
@onready var hit: AudioStreamPlayer = $hit

func _ready():
	animator = warrior
	sfx_attck = swip_1
	sfx_hit = hit
	maxHealth = 60
	damage = 20
	attack_cd = 1.5
	team = "ally"
	cost = 75
	type = "melee"
	
	super._ready()
	
	animator.play("idle")
