extends Area2D

signal done

export(Array, String, MULTILINE) var text: Array
export(Array, AudioStream) var audio_stream: Array
export(int, 0, 5) var delay: int = 0


onready var _voice_audio: AudioStreamPlayer = $AudioStreamPlayer
onready var _label: Label = $CanvasLayer/Label
onready var _tween: Tween = $Tween
onready var _timer: Timer = $Timer

var playing: bool = false


func _on_VoiceOver_body_entered(body: Node) -> void:
	if playing:
		return

	playing = true

	_timer.wait_time = delay

	if delay > 0:
		_timer.start()
		yield(_timer, "timeout")

	for i in range(len(text)):
		_label.text = text[i]
		_voice_audio.stream = audio_stream[i]

		_voice_audio.play()

		_tween.interpolate_property(_label, "modulate:a", 0, 1, .5)
		_tween.start()

		yield(_voice_audio, "finished")

		_tween.interpolate_property(_label, "modulate:a", 1, 0, 1, 0, 2)
		_tween.start()

		yield(_tween, "tween_all_completed")

	emit_signal("done")

	queue_free()
