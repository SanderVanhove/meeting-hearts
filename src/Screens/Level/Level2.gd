extends Level


onready var _start_over_voice: Node2D = $VoiceOvers/StartOverVoiceOver


func _ready() -> void:
	_player.connect("reset", self, "transport_startover_voice")


func transport_startover_voice() -> void:
	if not is_instance_valid(_start_over_voice):
		return

	_start_over_voice.position = _player.position
