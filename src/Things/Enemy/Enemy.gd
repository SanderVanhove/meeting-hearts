extends Node2D


const MOVEMENT_SPEED: float = 700.0


onready var _tween: Tween = $Tween
onready var _visual: Node2D = $Visual


func _on_Area_area_entered(area: Area2D) -> void:
	if area.is_in_group("heartbeat_ring"):
		go_to_position(area.global_position)


func go_to_position(new_position: Vector2) -> void:
	if _tween.is_active():
		return

	_tween.set_active(true)

	_tween.interpolate_property(_visual, "scale", _visual.scale, Vector2(1.5, 1.5), .2, Tween.TRANS_BOUNCE, Tween.EASE_OUT)

	var time = (position - new_position).length() / MOVEMENT_SPEED
	_tween.interpolate_property(self, "position", position, new_position, time, Tween.TRANS_SINE, Tween.EASE_OUT)
	_tween.start()

	yield(_tween, "tween_completed")

	_tween.interpolate_property(_visual, "scale", _visual.scale, Vector2.ONE, .4, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
	_tween.start()

	yield(_tween, "tween_all_completed")

	_tween.set_active(false)
