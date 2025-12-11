extends "res://Script/Entity/entity.gd"

@onready var long_archer: AnimatedSprite3D = $AnimatedSprite3D
@onready var throw_1: AudioStreamPlayer = $throw1
@onready var hit: AudioStreamPlayer = $hit

func _ready():
	animator = long_archer
	sfx_attck = throw_1
	sfx_hit = hit
	maxHealth = 40
	damage = 60
	attack_cd = 2
	team = "ally"
	cost = 5
	type = "ranged"
	
	super._ready()
	
	animator.play("idle")
