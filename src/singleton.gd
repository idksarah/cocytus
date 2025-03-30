extends Node

var last_checkpoint
var camera_position : Vector2
var camera_restart = false
var vertical_camera = false
var left_horizontal_camera = false
var right_horizontal_camera = false

var collectible_count : int
var death_count : int

func reset():
	get_tree().reload_current_scene()
	camera_restart = true
	#print(last_checkpoint)

func kill_player():
	death_count+=1
