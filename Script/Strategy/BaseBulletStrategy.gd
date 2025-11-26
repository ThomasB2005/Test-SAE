# res://Script/Strategies/BaseTurretStrategy.gd
class_name BaseTurretStrategy
extends Resource

# Appliqué une seule fois quand l'upgrade est acheté
func apply(turret: Entity) -> void:
	pass

# Optionnel : pour les upgrades qui ont besoin d'un update chaque frame
func update(turret: Entity, delta: float) -> void:
	pass
