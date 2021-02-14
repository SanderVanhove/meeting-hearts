extends Node2D


export(String, FILE) var next_level: String


onready var _smoke: ColorRect = $Smoke
onready var _spawn: Node2D = $Spawn
onready var _player: Player = $Player
onready var _goal: Node2D = $Goal
onready var _tween: Tween = $Tween


func _ready() -> void:
	_smoke.visible = true
	_player.position = _spawn.position
	_player.set_goal(_goal)

	modulate.a = 0

	_tween.interpolate_property(self, "modulate:a", 0, 1, 1)
	_tween.start()


func _on_EndVoiceOver_done() -> void:
	_tween.interpolate_property(self, "modulate:a", 1, 0, 1)
	_tween.start()

	yield(_tween, "tween_all_completed")

	get_tree().change_scene(next_level)
