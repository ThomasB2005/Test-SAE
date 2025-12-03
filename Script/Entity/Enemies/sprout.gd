extends "res://Script/Entity/entity.gd"

@onready var sprout: AnimatedSprite3D = $AnimatedSprite3D
@onready var attack_1: AudioStreamPlayer = $Attack
@onready var hit: AudioStreamPlayer = $Hit
@onready var death: AudioStreamPlayer = $Death
@onready var boss_spawn: AudioStreamPlayer = $BossSpawn
@onready var boss_felled: AudioStreamPlayer = $BossFelled
@onready var theme: AudioStreamPlayer = $Theme

func _ready():
	
	animator = sprout # Liaison de la variable générique de la classe mère
	sfx_attck = attack_1
	sfx_hit = hit
	sfx_death = death
	sfx_spawn = boss_spawn
	sfx_felled = boss_felled
	music = theme
	maxHealth = 150 # Initialisation des PV max
	damage = 15
	attack_cd = 3
	team = "enemie"
	is_boss = true

	super._ready()
	
	animator.play("idle")
