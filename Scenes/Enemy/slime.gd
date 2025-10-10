extends "res://Script/entity.gd"

@onready var slime:AnimatedSprite3D = $AnimatedSprite3D

var attack_slime = true
var attack_cd = 2.0

func _ready():
	maxHealth = 40.0
	currentHealth = maxHealth
	
	healthBar.max_value = maxHealth
	healthBar.value = currentHealth
	
	# Détecter aussi les Area3D qui entrent
	detection_area.area_entered.connect(_on_area_entered)
	
	slime.play("idle")

# Détecte les Area3D qui entrent
func _on_area_entered(area: Node3D):
	debug(area)
	
func debug(target: Node3D):
		
	while attack_slime and is_alive:
		
		# Animation
		self.attack(slime, attack_cd)
		
		await get_tree().create_timer(attack_cd).timeout
		
		self.take_damage1(15.0, slime) # debug
		
		await get_tree().create_timer(attack_cd).timeout
