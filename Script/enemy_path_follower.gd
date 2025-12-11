extends PathFollow3D

# Enemy properties
@export var speed: float = 1.0
@export var damage_to_base: int = 1

# Signals
signal enemy_reached_end(damage)
signal enemy_died

var has_damaged_base: bool = false
var is_moving: bool = true
var last_position: Vector3 = Vector3.ZERO
var death_signal_emitted: bool = false
var blocked_by: Node3D = null

func _ready():
	progress = 0
	
	loop = false
	rotation_mode = PathFollow3D.ROTATION_NONE
	
	# Store initial position for direction calculation
	last_position = global_position
	
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

	# Store initial position for direction tracking
	last_position = global_position

func _process(delta):
	# Check if entity is alive before moving
	var enemy_entity = get_node_or_null("Node3D")
	if enemy_entity and enemy_entity.get("is_alive") != null:
		if not enemy_entity.is_alive and not death_signal_emitted:
			# Enemy just died, stop moving and emit signal
			is_moving = false
			emit_signal("enemy_died")
			death_signal_emitted = true
			print("Enemy died signal emitted")
	
	# Check if the blocking warrior is still alive
	if blocked_by != null:
		if not is_instance_valid(blocked_by) or not blocked_by.get("is_alive") or not blocked_by.is_alive:
			# Warrior died or is invalid, resume movement
			blocked_by = null
			is_moving = true
			var animator = get_node_or_null("Node3D/AnimatedSprite3D")
			# Only play move if not attacking
			if animator and enemy_entity and enemy_entity.get("can_attack"):
				animator.play("move")
			print("Warrior died, enemy resuming movement")
	
	if is_moving:
		progress += speed * delta
		
		# Update facing direction based on horizontal movement
		var current_pos = global_position
		var direction = current_pos - last_position
		
		# Only change direction based on horizontal movement (x axis)
		# But always update last_position
		if abs(direction.x) > 0.001:  # Smaller threshold for better detection
			var animator = get_node_or_null("Node3D/AnimatedSprite3D")
			if animator:
				# If moving right (positive x), don't flip. If moving left (negative x), flip
				animator.flip_h = direction.x < 0
		
		# Always update last position even if we didn't change direction
		last_position = current_pos

func _on_hitbox_area_entered(area: Area3D):
	# Check if we hit the base's HitBox and haven't damaged it yet
	# Verify that the parent is actually the Base node
	if area.name == "BaseHitBox" and not has_damaged_base:
		var parent = area.get_parent()
		# Check if the parent is a Base
		if parent and parent.name.begins_with("Base"):
			has_damaged_base = true
			emit_signal("enemy_reached_end", damage_to_base)
			queue_free()
			
	# Stop only when hitting a UnitHitBox (melee units like warriors)
	# This prevents slimes from blocking each other since they have regular HitBox
	elif area.name == "UnitHitBox" and not has_damaged_base:
		var unit = area.get_parent()
		if unit and unit.get("is_alive"):
			blocked_by = unit
			is_moving = false
			# Don't force idle animation here, let entity.gd handle animations when stopped
			print("Enemy stopped by warrior: ", unit.name)
			
			# Notifier le script entity.gd pour qu'il attaque cette cible
			var enemy_entity = get_node_or_null("Node3D")
			if enemy_entity and enemy_entity.has_method("set_target_from_collision"):
				enemy_entity.set_target_from_collision(unit)
