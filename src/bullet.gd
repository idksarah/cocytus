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
var pre_still_time = 0.05
var still_shoot = false
var stopped = false

@onready var player : CharacterBody2D = $"../Player"
@onready var timer = $Timer
@onready var stop_timer = $StopTimer
@onready var collision = $CollisionShape2D

func _ready() -> void:
	if still_shoot:
		timer.wait_time = still_timer
		stop_timer.wait_time = pre_still_time
		stop_timer.start()
	else:
		timer.wait_time = reg_timer
	global_position = Vector2(pos.x + x_pos_offset, pos.y + y_pos_offset)
	timer.start()
	
func _process(delta: float) -> void:
	pass
	
func _on_timer_timeout():
	queue_free()

func _on_stop_timer_timeout():
	stopped = true

func _physics_process(delta: float):
	velocity = Vector2(x_vector * multiplier, y_vector * multiplier)
	if stopped:
		velocity = Vector2(0,0)
	move_and_slide()

func _on_collision_shape_2d_child_entered_tree(node: Node) -> void: # bullet should disappear when hit stuff but idc
	print('fuck ass')
	queue_free()
