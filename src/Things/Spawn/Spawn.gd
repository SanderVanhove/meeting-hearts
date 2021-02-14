extends Area2D

signal new_spawn(spawn)


func _on_Spawn_body_entered(body: Node) -> void:
	emit_signal("new_spawn", self)
