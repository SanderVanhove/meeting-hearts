extends Sprite
class_name Goal


onready var _tween: Tween = $Tween
onready var _beat1: AudioStreamPlayer2D = $Beat1
onready var _beat2: AudioStreamPlayer2D = $Beat2
onready var _timer: Timer = $Timer


func do_callout() -> void:
	_beat1.play()
	spawn_noise_ring(10000, 1.5)

	_timer.start()
	yield(_timer, "timeout")

	_beat2.play()
	spawn_noise_ring(10000, 1.5)


func spawn_noise_ring(radius: float = 200, time: float = .3) -> void:
	var ring = Ring.new()
	ring.collide = false
	add_child(ring)

	_tween.interpolate_property(ring, "radius", 0, radius, time, Tween.TRANS_SINE, Tween.EASE_OUT)
	_tween.interpolate_property(ring, "opacity", 1, 0, time, Tween.TRANS_SINE, Tween.EASE_OUT)
	_tween.interpolate_property(ring, "width", 10, 0, time, Tween.TRANS_SINE, Tween.EASE_OUT)

	_tween.start()

	yield(_tween, "tween_all_completed")

	ring.queue_free()
