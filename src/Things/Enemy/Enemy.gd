extends Node2D


const MOVEMENT_SPEED: float = 550.0


onready var _tween: Tween = $Tween


func _on_Area_area_entered(area: Area2D) -> void:
	if area.is_in_group("heartbeat_ring"):
		go_to_position(area.global_position)


func go_to_position(new_position: Vector2) -> void:
	_tween.stop_all()

	var time = (position - new_position).length() / MOVEMENT_SPEED
	_tween.interpolate_property(self, "position", position, new_position, time, Tween.TRANS_SINE, Tween.EASE_OUT)
	_tween.start()
