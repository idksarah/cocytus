extends TileMapLayer

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		Singleton.kill_player()
		Singleton.reset()
