
@tool
class_name Item
extends Resource

@export var title : String = ""
@export var icon : Texture2D
@export var price : int = 75
@export var strategy : BaseTurretStrategy   # ← Stratégie de TOURELLE
