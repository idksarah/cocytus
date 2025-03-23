extends Area2D

@onready var player = self.get_parent().get_parent().get_parent().get_node("Player")
@onready var timer = $Timer

var in_out = false
var should_start_timer = true
var wait_time = .1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player.in_wind = true
		player.big_wind = true
func _on_body_exited(_body: Node2D) -> void:
	player.in_wind = false
	player.big_wind = false
	
func _on_in_out_body_entered(body: Node2D) -> void:
		if body.is_in_group("Player"):
			print('kinda in wind')
			player.kinda_in_wind = true

func _on_in_out_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print('not kinda in wind')
		player.kinda_in_wind = false
 
