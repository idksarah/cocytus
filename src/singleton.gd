extends Node

var last_checkpoint
var camera_position : Vector2
var camera_restart = false
var vertical_camera = false
var left_horizontal_camera = false
var right_horizontal_camera = false
var fade_in = false
var fade_out = false
var playing_game = true

var speedrun_time : float
var collectible_count : int
var death_count : int

func reset():
	fade_out = true
	get_tree().reload_current_scene()
	camera_restart = true
	#print(last_checkpoint)

func kill_player():
	death_count+=1
