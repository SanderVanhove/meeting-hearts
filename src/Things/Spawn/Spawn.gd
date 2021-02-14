extends Area2D

signal new_spawn(spawn)

export var is_current: bool = false


func _on_Spawn_body_entered(body: Node) -> void:
	emit_signal("new_spawn", self)
