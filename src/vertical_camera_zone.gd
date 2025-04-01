extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Singleton.vertical_camera = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Singleton.vertical_camera = false
