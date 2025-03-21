extends CharacterBody2D

@export var speed = 200

var direction : Vector2
var timeout = 3

func _ready():
	await get_tree().create_timer(timeout).timeout
	queue_free()
	
func set_direction(bulletDirection):
	direction = bulletDirection
	rotation_degrees = rad_to_deg(global_position.angle_to_point(global_position+direction))
	
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	
func _on_body_entered(body):
	
