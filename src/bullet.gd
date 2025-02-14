extends CharacterBody2D

var pos:Vector2
var x_pos_offset = 20 # bullet spawn logic doesn't accoutn for up down or varying shooting positions
var y_pos_offset = 10
var dir : float
var x_vector = 1
var y_vector = 1
var multiplier = 500

var reg_timer = 1
var still_timer = 3
var still_shoot = false

@onready var player : CharacterBody2D = $"../Player"
@onready var timer = $Timer

func _ready() -> void:
	if still_shoot:
		timer.wait_time = still_timer
	else:
		timer.wait_time = reg_timer
	global_position = Vector2(pos.x + x_pos_offset, pos.y + y_pos_offset)
	print(timer.wait_time)
	
func _process(delta: float) -> void:
	print(still_shoot)
	pass
	
func _on_timer_timeout():
	queue_free()

func _physics_process(delta: float):
	velocity = Vector2(x_vector * multiplier, y_vector * multiplier)
	if still_shoot:
		velocity = Vector2(0,0)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	queue_free()
