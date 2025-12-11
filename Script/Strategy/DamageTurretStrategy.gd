class_name DamageTurretStrategy
extends BaseTurretStrategy

@export var damage_bonus: int = 15

func apply_to_turret(turret: Node3D) -> void:
	if turret.has_method("get") and "damage" in turret:
		turret.damage += damage_bonus
		print("💥 Dégâts augmentés de +%d → Total: %d" % [damage_bonus, turret.damage])
