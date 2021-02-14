extends Sprite
class_name Arrow

const HALF_PI: float = PI / 2

var goal: Node2D

onready var _tween: Tween = $Tween2


func _process(delta: float) -> void:
	if goal:
		rotation = (global_position - goal.position).angle() + HALF_PI


func show_direction(visible: bool) -> void:
	var new_alpha: float = 1 if visible else 0
	_tween.interpolate_property(self, "modulate:a", modulate.a, new_alpha, .5)
	_tween.start()
