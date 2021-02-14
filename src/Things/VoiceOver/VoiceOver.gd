extends Area2D


export(String, MULTILINE) var text: String
export(AudioStream) var audio_stream: AudioStream


onready var _voice_audio: AudioStreamPlayer = $AudioStreamPlayer
onready var _label: Label = $CanvasLayer/Label
onready var _tween: Tween = $Tween


func _ready() -> void:
	_label.text = text
	_voice_audio.stream = audio_stream


func _on_VoiceOver_body_entered(body: Node) -> void:
	if _voice_audio.playing:
		return

	_voice_audio.play()

	_tween.interpolate_property(_label, "modulate:a", 0, 1, .5)
	_tween.start()

	yield(_voice_audio, "finished")

	_tween.interpolate_property(_label, "modulate:a", 1, 0, 1, 0, 2, 3)
	_tween.start()

	yield(_tween, "tween_all_completed")

	queue_free()
