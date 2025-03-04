extends Area2D

var player
var checkpoint_manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("Player")
	checkpoint_manager = get_parent().get_node("Checkpoint_manager")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		kill_player()
		
func kill_player():
	player.global_position = checkpoint_manager.last_location
