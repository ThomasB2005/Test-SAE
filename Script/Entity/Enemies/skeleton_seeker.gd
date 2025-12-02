extends "res://Script/Entity/entity.gd"

@onready var skeleton_seeker: AnimatedSprite3D = $AnimatedSprite3D
@onready var attack_1: AudioStreamPlayer = $attack
@onready var hit: AudioStreamPlayer = $hit
@onready var death: AudioStreamPlayer = $death
@onready var boss_spawn: AudioStreamPlayer = $bossSpawn
@onready var boss_felled: AudioStreamPlayer = $bossFelled
@onready var theme: AudioStreamPlayer = $music

func _ready():
	
	animator = skeleton_seeker # Liaison de la variable générique de la classe mère
	sfx_attck = attack_1
	sfx_hit = hit
	sfx_death = death
	sfx_spawn = boss_spawn
	sfx_felled = boss_felled
	music = theme
	maxHealth = 100 # Initialisation des PV max
	damage = 2
	attack_cd = 4
	team = "enemie"
	is_boss = true

	super._ready()
	
	animator.play("idle")
