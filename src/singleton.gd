extends Node

var last_checkpoint
var camera_position : Vector2
var camera_restart = false

var collectible_count : int
var death_count : int

func reset():
	get_tree().reload_current_scene()
	camera_restart = true

func kill_player():
	death_count+=1
