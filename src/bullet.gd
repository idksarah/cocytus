extends CharacterBody2D

var pos:Vector2
var x_pos_offset = 2
var y_pos_offset = 2
var dir : float
var x_vector = 1
var y_vector = 1
var multiplier = 400

var stopped = false

@onready var timer = $Area2D/Timer
@onready var collision = $collision_box

func _ready() -> void:
	global_position = Vector2(pos.x + x_pos_offset, pos.y + y_pos_offset)
	timer.start()
	name = "bullet"
	
func _on_timer_timeout():
	queue_free()

func _physics_process(_delta: float):
	velocity = Vector2(x_vector * multiplier, y_vector * multiplier)
	if stopped:
		velocity = Vector2(0,0)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("parent name", body.get_parent().name)
	if body.name == "Player" or body.name.substr(0,7) == "bullet":
		return
	print("name",body.name)
	print("name",body.name.substr(0,7))
	queue_free()	
