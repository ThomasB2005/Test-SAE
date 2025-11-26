
class_name MultiShotTurretStrategy
extends BaseTurretStrategy
@export var multi_shot_bonus : int = 1
func apply(turret: Entity): turret.multi_shot += multi_shot_bonus
