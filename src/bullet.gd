extends CharacterBody2D

var pos:Vector2
var dir : float
var x_vector = 1
var y_vector = 1
var multiplier = 500

@onready var player : CharacterBody2D = $"../Player"

func _ready() -> void:
	global_position = pos
	
func _process(delta: float) -> void:
	pass
	
func _on_timer_timeout():
	queue_free()

func _physics_process(delta: float):
	velocity = Vector2(x_vector * multiplier, y_vector * multiplier)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == player:
		return
	queue_free()
