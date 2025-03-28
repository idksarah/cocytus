func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print('kill!')
		Singleton.kill_player()
		Singleton.reset()
