
class_name RangeTurretStrategy
extends BaseTurretStrategy
@export var range_bonus : int = 15
func apply(turret: Entity): turret.attack_range += range_bonus
