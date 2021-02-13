extends LightOccluder2D


onready var _collision_polygon: CollisionPolygon2D = $StaticBody/CollisionPolygon


func _ready() -> void:
	_collision_polygon.polygon = occluder.polygon
