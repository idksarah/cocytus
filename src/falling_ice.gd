extends RigidBody2D

func _process(delta: float) -> void:
	sleeping = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == ("Bullet"):
		set_process(false)
		sleeping = false
