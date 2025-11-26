extends "res://Script/Entity/entity.gd"

@onready var mage: AnimatedSprite3D = $AnimatedSprite3D
@onready var throw_1: AudioStreamPlayer = $throw1
@onready var hit: AudioStreamPlayer = $hit

func _ready():
	animator = mage
	sfx_attck = throw_1
	sfx_hit = hit
	maxHealth = 40.0
	damage = 3
	attack_cd = 2.0
	team = "ally"
	
	super._ready()
	
	animator.play("idle")
