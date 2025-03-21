extends CollisionShape2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.score += 1
		self.get_parent().queue_free()
