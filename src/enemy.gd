extends CharacterBody2D

@onready var root = get_parent()
@onready var player = root.get_node("Player")

var x_speed = 2
var y_speed = 2

func _ready():
	pass

func init(delta):
	if not is_on_floor():
		velocity += 2 * get_gravity() * delta

func _physics_process(delta: float) -> void:
	init(delta)
	if(player.global_position.x > global_position.x): #right
		global_position.x += x_speed
	else: #left
		global_position.x -= x_speed
	if(player.global_position.y > global_position.y): #down
		global_position.y += y_speed
	else: #up 
		global_position.y -= y_speed
	move_and_slide()

func _on_rigid_body_2d_body_entered(body: Node) -> void:
	if body is CharacterBody2D and body.name == "bullet":
		print('love u aiden ma warzhou eric hou? sophia liu choi hyunkwook')
		queue_free()
