# res://Script/entity.gd
extends Node2D
class_name Entity

@export var damage : int = 20
@export var attack_cooldown : float = 2.0
@export var attack_range : int = 200
@export var multi_shot : int = 1

var current_target : Node = null
var attack_timer : Timer
var strategies : Array[BaseTurretStrategy] = []

signal hit_enemy(turret: Entity, enemy: Node)

func _ready():
	attack_timer = Timer.new()
	attack_timer.wait_time = attack_cooldown
	attack_timer.autostart = true
	attack_timer.timeout.connect(_attack)
	add_child(attack_timer)

func add_strategy(strategy: BaseTurretStrategy):
	if strategy:
		strategies.append(strategy)
		strategy.apply(self)  # Applique immédiatement

func _process(delta):
	for s in strategies:
		s.update(self, delta)

func _attack():
	current_target = _find_target()
	if not current_target: return
	
	for i in range(multi_shot):
		_shoot_at(current_target)
		await get_tree().create_timer(0.1).timeout  # petit décalage entre tirs

func _shoot_at(target):
	# Ici tu fais ton tir visuel (AnimatedSprite, particule, etc.)
	# Exemple pour archer :
	if has_node("AnimatedSprite3D"):
		$AnimatedSprite3D.play("attack")
	
	# Dégâts
	target.take_damage(damage)
	emit_signal("hit_enemy", self, target)

func _find_target() -> Node:
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closest = null
	var best = attack_range * attack_range
	for e in enemies:
		var d = global_position.distance_squared_to(e.global_position)
		if d < best:
			best = d
			closest = e
	return closest
