# res://Script/Resources/BaseTurretStrategy.gd
class_name BaseTurretStrategy
extends Resource

# Méthode abstraite à implémenter dans les classes dérivées
func apply_to_turret(turret: Node3D) -> void:
	push_warning("apply_to_turret() doit être implémentée dans la classe dérivée")
