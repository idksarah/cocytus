extends Area2D

@onready var player = get_parent().get_parent().get_parent().get_node("Player")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player.fly_boost = true
		queue_free()
