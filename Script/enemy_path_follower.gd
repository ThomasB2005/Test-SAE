extends PathFollow3D

# Enemy properties
@export var speed: float = 1.0
@export var health: int = 10
@export var damage_to_base: int = 1

# Signals
signal enemy_reached_end(damage)
signal enemy_died

func _ready():
	progress = 0
	
	loop = false
	rotation_mode = PathFollow3D.ROTATION_NONE

func _process(delta):
	progress += speed * delta

	if progress_ratio >= 1.0:
		reach_end()

func reach_end():
	emit_signal("enemy_reached_end", damage_to_base)
	queue_free()

func take_damage(amount: int):
	health -= amount
	print(health)
	if health <= 0:
		die()

func die():
	emit_signal("enemy_died")
	queue_free()
