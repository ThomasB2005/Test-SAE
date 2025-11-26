# DamageTurretStrategy.gd
class_name DamageTurretStrategy
extends BaseTurretStrategy
@export var damage_bonus : int = 15
func apply(turret: Entity): turret.damage += damage_bonus
