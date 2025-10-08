extends Node3D

@export var speed: float = 20.0
@export var lifetime: float = 3.0  # Durée avant destruction

func _ready():
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _process(delta):
	translate(-transform.basis.z * speed * delta)
