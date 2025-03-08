extends CharacterBody2D

@onready var animator = $AnimatedSprite2D
@onready var move_timer = $Timer
@onready var bullet = preload("res://Bullet.tscn")

var move_duration = 0.1

var mouse_pos : Vector2
var char_pos : Vector2

var cur_speed = 0.0
const reg_speed = 200.0
var x_direction_multiplier = 0.04
var y_direction_multiplier = 0.08
var max_x_direction = 1
var max_y_direction = 1.75

var cur_bullets_shot = 0
var max_bullets_shot = 1

@export var x_tolerance = 30
@export var y_tolerance = 40

var bullet_x_offset = 10
var bullet_y_offset = 10

var player_x_accel := Input.get_axis("better_left", "better_right")
var player_y_accel := Input.get_axis("better_down", "better_up")

enum state {left_shoot, right_shoot, down_shoot, up_shoot, left_down_shoot, left_up_shoot, right_down_shoot, right_up_shoot}
var current_state : state

func _physics_process(delta: float) -> void:
	init(delta)
	track_mouse(delta)
	player_animations()
	move_and_slide()
	apply_gravity(delta)
	restart()
	
func init(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta * 0.7

func restart(p_restart = false):
	if(Input.is_action_just_pressed("restart") or p_restart):
		get_parent().get_node("Death_zone").kill_player()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += get_gravity().y * delta * 1.5
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
		player_shoot(delta)
	elif move_timer.time_left == 0:
		velocity *= 0.88  # Multiply by a factor between 0 and 1

		#velocity.x = lerp(velocity.x, 0., .08)
		#velocity.y = lerp(velocity.y, 0., .07)

func player_shoot(_delta):
	if(is_on_floor()):
		cur_bullets_shot = 0
		
	if(is_on_floor() || cur_bullets_shot < max_bullets_shot):
		player_x_accel = -(mouse_pos.x - char_pos.x) * x_direction_multiplier
		player_y_accel = -(mouse_pos.y - char_pos.y) * y_direction_multiplier
		
		player_x_accel = clamp(player_x_accel, -max_x_direction, max_x_direction)
		player_y_accel = clamp(player_y_accel, -max_y_direction, max_y_direction)
		
		velocity.x = player_x_accel * reg_speed
		velocity.y = player_y_accel * reg_speed
		
		move_timer.wait_time = move_duration
		move_timer.start()
		
		#u should modularize this shyt
		if not is_on_floor():
			cur_bullets_shot+=1
		
		# bullet
		await get_tree().create_timer(.2).timeout
		
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.pos = animator.global_position
		
		if player_x_accel > 0:
			bullet_instance.x_pos_offset *= -1
			
		if player_y_accel > 0:
			bullet_instance.y_pos_offset *= -1
			
		bullet_instance.x_vector = -player_x_accel
		bullet_instance.y_vector = -player_y_accel
			
		get_parent().add_child(bullet_instance)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.get_parent().get_name() == "Enemey" && area.get_name() == "kill_box_area_2d"):
		restart(true)
