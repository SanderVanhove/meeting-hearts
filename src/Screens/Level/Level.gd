extends Node2D


onready var _smoke: ColorRect = $Smoke


func _ready() -> void:
	_smoke.visible = true
