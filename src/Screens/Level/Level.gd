extends Node2D


onready var _smoke: ColorRect = $Smoke
onready var _spawn: Node2D = $Spawn
onready var _player: Player = $Player
onready var _goal: Node2D = $Goal


func _ready() -> void:
	_smoke.visible = true
	_player.position = _spawn.position
	_player.set_goal(_goal)
