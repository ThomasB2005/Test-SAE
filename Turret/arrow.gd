extends RigidBody3D

@export var speed: float = 20.0

func _ready():
	linear_velocity = transform.basis.z * -speed
	await get_tree().create_timer(3).timeout
	
	queue_free()
	
