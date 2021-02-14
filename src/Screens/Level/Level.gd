extends Node2D
class_name Level


export(String, FILE) var next_level: String


onready var _smoke: ColorRect = $Smoke
onready var _spawn: Node2D = $Spawn
onready var _spawns: Node2D = $Spawns
onready var _player: Player = $Player
onready var _goal: Node2D = $Goal
onready var _tween: Tween = $Tween
onready var _dead_timer: Timer = $DeadTimer
onready var _enemies: Node2D = $Enemies


func _ready() -> void:
	for spawn in _spawns.get_children():
		spawn.connect("new_spawn", self, "new_spawn")

		if spawn.is_current:
			_spawn = spawn

	_smoke.visible = true
	_player.position = _spawn.position
	_player.connect("died", self, "player_respawn")
	_player.set_goal(_goal)

	modulate.a = 0

	_tween.interpolate_property(self, "modulate:a", 0, 1, 1)
	_tween.start()


func _on_EndVoiceOver_done() -> void:
	_tween.interpolate_property(self, "modulate:a", 1, 0, 1)
	_tween.start()

	yield(_tween, "tween_all_completed")

	get_tree().change_scene(next_level)


func new_spawn(spawn: Node2D) -> void:
	_spawn = spawn


func player_respawn() -> void:
	_dead_timer.start()
	yield(_dead_timer, "timeout")

	_tween.interpolate_property(self, "modulate:a", 1, 0, 1)
	_tween.start()
	yield(_tween, "tween_all_completed")

	_player.position = _spawn.position
	_player.reset()

	for enemy in _enemies.get_children():
		enemy.reset()

	_tween.interpolate_property(self, "modulate:a", 0, 1, 1)
	_tween.start()
