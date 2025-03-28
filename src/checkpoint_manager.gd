extends Node2D

var player

func _ready() -> void:
	player = get_parent().get_node("Player")
	if Singleton.last_checkpoint == null:
		print('this butch null')
		Singleton.last_checkpoint = player.global_position
