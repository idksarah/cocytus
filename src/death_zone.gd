extends Area2D

var checkpoint_manager
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkpoint_manager = $"../Check_point_manager"
	player = get_parent().get_node("Player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func killPlayer():
	player.global_position = checkpoint_manager.global_position

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		killPlayer()
