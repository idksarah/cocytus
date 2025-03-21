extends Area2D

var checkpoint_manager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoint_manager = get_parent().get_parent().get_node("Checkpoint_manager")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	pass
	#if body.is_in_group("Player"):
		#print(checkpoint_manager.last_location)
		#checkpoint_manager.last_location = $Respawn_point.global_position
