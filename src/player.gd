extends CharacterBody2D

@onready var animator = $AnimatedSprite2D
@onready var bullet = preload("res://Bullet.tscn")

var mouse_pos : Vector2
var char_pos : Vector2

var cur_speed = 0.0
const reg_speed = 300.0
const giga_speed = 400.0
const jump_velocity = -800.0
const coyote_time = 0.2
var curr_coyote_time = 0
var move_duration = 0.1
var giga_move_duration = 0.15

var cur_bullets_shot = 0
var max_bullets_shot = 2
var still_shoot = false

var move_timer = 0.0

var x_tolerance = 30
var y_tolerance = 40
var x_direction_multiplier = 0.02
var y_direction_multiplier = 0.02
var max_x_direction = 4
var max_y_direction = 3
var bullet_x_offset = 10
var bullet_y_offset = 10

enum state {left_shoot, right_shoot, down_shoot, up_shoot, left_down_shoot, left_up_shoot, right_down_shoot, right_up_shoot}
var current_state : state

func _physics_process(delta: float) -> void:
	init(delta)
	track_mouse(delta)
	player_animations()
	move_and_slide()
	
func init(delta):
	if not is_on_floor():
		velocity += 2 * get_gravity() * delta

func player_animations():
	if current_state == state.left_shoot || current_state == state.left_up_shoot || current_state == state.left_down_shoot:
		animator.play("left_shoot")
	elif current_state == state.right_shoot || current_state == state.right_up_shoot || current_state == state.right_down_shoot:
		animator.play("right_shoot")
	elif current_state == state.up_shoot || current_state == state.right_up_shoot || current_state == state.right_down_shoot:
		animator.play("up_shoot")
	elif current_state == state.down_shoot || current_state == state.right_up_shoot || current_state == state.right_down_shoot:
		animator.play("down_shoot")

func track_mouse(delta):
	mouse_pos = get_global_mouse_position()
	char_pos = global_position
	if(mouse_pos.x < char_pos.x && abs(mouse_pos.x - char_pos.x) > x_tolerance):
		if(mouse_pos.y < char_pos.y - y_tolerance ):
			current_state = state.left_down_shoot
			#print("left up")
		elif(mouse_pos.y > char_pos.y + y_tolerance):
			current_state = state.left_up_shoot
			#print("left down")
		else:
			current_state = state.left_shoot
			#print("left")
	elif(mouse_pos.x > char_pos.x && abs(mouse_pos.x - char_pos.x) > x_tolerance):
		if(mouse_pos.y < char_pos.y - y_tolerance):
			current_state = state.right_down_shoot
			#print("right up")
		elif(mouse_pos.y > char_pos.y + y_tolerance):
			current_state = state.right_up_shoot
			#print("right down")
		else:
			current_state = state.right_shoot
			#print("right")
	else:
		if(mouse_pos.y < char_pos.y - y_tolerance):
			current_state = state.up_shoot
			#print("up")
		elif(mouse_pos.y > char_pos.y + y_tolerance):
			current_state = state.down_shoot
			#print("down")
	
	if(Input.is_action_just_pressed("shoot")):
		still_shoot = false
		player_shoot(delta)
	elif (Input.is_action_just_pressed("still_shoot")):
		still_shoot = true
		player_shoot(delta)
	# continue moving for move_duration even after player releases key
	elif move_timer > 0:
		move_timer-= delta
	else:
		velocity.x = move_toward(velocity.x, 0, reg_speed)

func player_shoot(delta):
	print(still_shoot)
	if(is_on_floor()):
		cur_bullets_shot = 0
	var x_direction := Input.get_axis("better_left", "better_right")
	var y_direction := Input.get_axis("better_down", "better_up")
	
	if(is_on_floor() || cur_bullets_shot < max_bullets_shot):
		
		x_direction = -(mouse_pos.x - char_pos.x) * x_direction_multiplier
		y_direction = -(mouse_pos.y - char_pos.y) * y_direction_multiplier
		
		x_direction = clamp(x_direction, -max_x_direction, max_x_direction)
		y_direction = clamp(y_direction, -max_y_direction, max_y_direction)
		
		velocity.x = x_direction * reg_speed
		velocity.y = y_direction * reg_speed
		move_timer = move_duration
		
		if not is_on_floor():
			cur_bullets_shot+=1
		
		await get_tree().create_timer(.2).timeout
		
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.pos = animator.global_position
		if x_direction > 0:
			bullet_instance.x_pos_offset *= -1
		if y_direction > 0:
			bullet_instance.y_pos_offset *= -1
		bullet_instance.x_vector = -x_direction
		bullet_instance.y_vector = -y_direction
		get_parent().add_child(bullet_instance)
		
		if still_shoot:
			bullet_instance.still_shoot = true
			bullet_instance.velocity = Vector2(0,0)
		
