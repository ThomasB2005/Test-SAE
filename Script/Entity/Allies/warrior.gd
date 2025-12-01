extends "res://Script/Entity/entity.gd"

@onready var warrior: AnimatedSprite3D = $AnimatedSprite3D
@onready var swip_1: AudioStreamPlayer = $swip1
@onready var hit: AudioStreamPlayer = $hit

func _ready():
	animator = warrior
	#sfx_attck = swip_1
	sfx_hit = hit
	maxHealth = 40
	damage = 15
	attack_cd = 2
	team = "ally"
	
	super._ready()
	
	animator.play("idle")
