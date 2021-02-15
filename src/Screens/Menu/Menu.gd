extends Node2D


onready var _tween: Tween = $Tween


func _ready() -> void:
	modulate.a = 0
	_tween.interpolate_property(self, "modulate:a", 0, 1, .5)
	_tween.start()


func _on_Label2_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		OS.shell_open("https://twitter.com/SanderVhove")


func _on_Button_pressed() -> void:
	get_tree().change_scene("res://Screens/Level/Level1.tscn")
