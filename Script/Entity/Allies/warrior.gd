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
	type = "melee"
	
	super._ready()
	
	# S'assurer que la UnitHitBox est bien configurée pour être détectable
	var unit_hitbox = get_node_or_null("UnitHitBox")
	if unit_hitbox:
		unit_hitbox.collision_layer = 1
		unit_hitbox.collision_mask = 0
		unit_hitbox.monitoring = false
		unit_hitbox.monitorable = true
	
	animator.play("idle")
