extends "res://Script/entity.gd"

@onready var archer:AnimatedSprite3D = $AnimatedSprite3D

var can_shoot = true
var shoot_cooldown = 2.0

func _ready():
	maxHealth = 60.0
	currentHealth = maxHealth
	
	healthBar.max_value = maxHealth
	healthBar.value = currentHealth
	
	# Détecter aussi les Area3D qui entrent
	detection_area.area_entered.connect(_on_area_entered)
	
	archer.play("idle")
		
# Détecte les Area3D qui entrent
func _on_area_entered(area: Node3D):
	shoot_at_target(area)
	
func take_damage(damage: float):
	healthBar.value -= damage
	print("-----------J'AI ", healthBar.value, " HP -------------") # debug
	if healthBar.value <= 0:
		can_shoot = false
		archer.play("death")
		print("Je suis mort") # debug
		await get_tree().create_timer(4.0).timeout
		queue_free()
	

func shoot_at_target(target: Node3D):
	if not can_shoot:
		return
		
	while can_shoot:
		# Animation
		archer.play("shooting")
		print("Je tire") # debug
		await archer.animation_finished
		archer.play("idle")
		await get_tree().create_timer(shoot_cooldown).timeout
		
		self.take_damage(40.0) # debug
