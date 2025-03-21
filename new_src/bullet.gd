extends Area2D

@export var speed = 300

var direction : Vector2
var timeout = 3

func _ready():
	await get_tree().create_timer(timeout).timeout
	queue_free()
	
func set_direction(bulletDirection):
	direction = bulletDirection
	rotation_degrees = rad_to_deg(direction.angle())
	
func _physics_process(delta: float) -> void:
	global_position += direction * speed * delta
	
func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		queue_free()
