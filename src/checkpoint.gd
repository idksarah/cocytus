extends Area2D

var checkpoint_manager

func _ready() -> void:
	checkpoint_manager = get_parent().get_parent().get_node("Checkpoint_manager")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print('name', name)
		print('respawn point', $Respawn_point.global_position)
		Singleton.last_checkpoint = $Respawn_point.global_position
