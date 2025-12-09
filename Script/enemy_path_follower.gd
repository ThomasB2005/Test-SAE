extends PathFollow3D

# Enemy properties
@export var speed: float = 1.0
@export var damage_to_base: int = 1

# Signals
signal enemy_reached_end(damage)
signal enemy_died

var has_damaged_base: bool = false
var is_moving: bool = true

func _ready():
	progress = 0
	
	loop = false
	rotation_mode = PathFollow3D.ROTATION_NONE
	
	# Connect to the HitBox area_entered signal if it exists
	var hitbox = get_node_or_null("Node3D/HitBox")
	if hitbox and hitbox is Area3D:
		hitbox.area_entered.connect(_on_hitbox_area_entered)
	
	# Connect to the entity's death to emit our own signal
	var enemy_entity = get_node_or_null("Node3D")
	if enemy_entity:
		# We'll monitor is_alive in _process to detect death
		pass
	
	# Start the move animation
	var animator = get_node_or_null("Node3D/AnimatedSprite3D")
	if animator:
		animator.play("move")

func _process(delta):
	# Check if entity is alive before moving
	var enemy_entity = get_node_or_null("Node3D")
	if enemy_entity and enemy_entity.get("is_alive") != null:
		if not enemy_entity.is_alive and is_moving:
			# Enemy just died, stop moving and emit signal
			is_moving = false
			emit_signal("enemy_died")
			print("Enemy died signal emitted")
	
	if is_moving:
		progress += speed * delta

func _on_hitbox_area_entered(area: Area3D):
	# Check if we hit the base's HitBox and haven't damaged it yet
	# Verify that the parent is actually the Base node
	if area.name == "HitBox" and not has_damaged_base:
		var parent = area.get_parent()
		# Check if the parent is a Base
		if parent and parent.name.begins_with("Base"):
			has_damaged_base = true
			emit_signal("enemy_reached_end", damage_to_base)
			queue_free()
