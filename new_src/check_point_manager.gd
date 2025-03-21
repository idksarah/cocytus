extends Node2D

var last_location
var player
var check_point_manager

func _ready() -> void:
	player = get_parent().get_node("Player")
	last_location = player.global_position
	
func _process(delta:float) -> void:
	pass
	
