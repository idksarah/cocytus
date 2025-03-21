extends CharacterBody2D

@onready var root = get_parent()
@onready var player = root.get_node("Player")

var x_speed = 1.5
var y_speed = 1.5
var should_chase_player = false

func _ready():
	pass

func init(delta):
	if not is_on_floor():
		velocity += 2 * get_gravity() * delta

func _physics_process(delta: float) -> void:
	init(delta)
	chase_player()
	move_and_slide()

func _on_hit_box_area_entered(area: Area2D) -> void:
	if(area.get_parent().name.substr(0, 6) == "bullet"):
		queue_free()

func _on_vision_area_entered(area: Area2D) -> void:
	if(area.get_parent().name == "Player"):
		should_chase_player = true
	
func chase_player():
	if should_chase_player:
		if(player.global_position.x > global_position.x): 
			global_position.x += x_speed #right
		else: 
			global_position.x -= x_speed #left
		if(player.global_position.y > global_position.y): 
			global_position.y += y_speed #down
		else: 
			global_position.y -= y_speed #up 
