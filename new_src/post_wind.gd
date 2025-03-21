extends Area2D

@onready var wind = $"."

func _on_body_exited(body: Node2D) -> void:
	wind.outside_wind = true
