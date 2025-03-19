extends Node2D

@export var shootSpeed = .3

@onready var marker_2d = $Marker2D
@onready var timer = $Timer

const BULLET = preload("res://bullet.tscn")

var can_shoot = true
var bullet_direction = Vector2(1,0)

func _ready():
	timer.wait_time = shootSpeed
	
func shoot(x, y):
	if can_shoot:
		can_shoot = false
		timer.start()
		
		bullet_direction = Vector2(-x, -y).normalized()
		
		var bulletNode = BULLET.instantiate()
		bulletNode.set_direction(bullet_direction)
		get_tree().root.add_child(bulletNode)
		bulletNode.global_position = marker_2d.global_position

func _on_timer_timeout() -> void:
	can_shoot = true
