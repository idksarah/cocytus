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
var max_x_direction = 1.2
var max_y_direction = 1.75
var min_x_direction = .1
var min_y_direction = .2

var cur_bullets_shot = 0
var max_bullets_shot = 1

@export var x_tolerance = 10
@export var y_tolerance = 0

var bullet_x_offset = 10
var bullet_y_offset = 10

var player_x_accel := Input.get_axis("better_left", "better_right")
var player_y_accel := Input.get_axis("better_down", "better_up")

enum state {left, right, down, up, left_down, left_up, right_down, right_up}
var current_state : state

var score = 0

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
	match current_state:
		state.left: animator.play("left")
		state.left_up: animator.play("left_up")
		state.left_down: animator.play("left_down")
		state.right: animator.play("right")
		state.right_up: animator.play("right_up")
		state.right_down: animator.play("right_down")
		state.up: animator.play("up")
		state.down: animator.play("down")


func track_mouse(delta):
	mouse_pos = get_global_mouse_position()
	char_pos = global_position
	
	var x_diff = mouse_pos.x - char_pos.x
	var y_diff = mouse_pos.y - char_pos.y

	if abs(x_diff) > x_tolerance:  # Ensure significant horizontal movement
		if x_diff < 0:  # Left side
			if y_diff > y_tolerance:
				current_state = state.left_down
			elif y_diff < -y_tolerance:
				current_state = state.left_up
			else:
				current_state = state.left
		else:  # Right side
			if y_diff > y_tolerance:
				current_state = state.right_down
			elif y_diff < -y_tolerance:
				current_state = state.right_up
			else:
				current_state = state.right
	else:  # Mostly vertical movement
		if y_diff < -y_tolerance:
			current_state = state.up
		elif y_diff > y_tolerance:
			current_state = state.down

	if Input.is_action_just_pressed("shoot"):
		player_shoot(delta)
	elif move_timer.time_left == 0:
		velocity.y *= 0.86
		velocity.x *= 0.82


func player_shoot(_delta):
	if(is_on_floor()):
		cur_bullets_shot = 0
		
	if(is_on_floor() || cur_bullets_shot < max_bullets_shot):
		player_x_accel = -(mouse_pos.x - char_pos.x) * x_direction_multiplier
		player_y_accel = -(mouse_pos.y - char_pos.y) * y_direction_multiplier
		
		var x_sign = sign(player_x_accel)
		var y_sign = sign(player_y_accel)
		
		player_x_accel = x_sign * clamp(abs(player_x_accel), min_x_direction, max_x_direction)
		player_y_accel = y_sign * clamp(abs(player_y_accel), min_y_direction, max_y_direction) # set a min movement too
		
		velocity.x = player_x_accel * reg_speed
		velocity.y = player_y_accel * reg_speed
		
		move_timer.wait_time = move_duration
		move_timer.start()
		
		#u should move this into bullet
		if not is_on_floor():
			cur_bullets_shot+=1
		
		# bullet
		
		var bullet_instance = bullet.instantiate() as Node2D
		bullet_instance.pos = animator.global_position
		
		if player_x_accel > 0:
			bullet_instance.x_pos_offset *= -1
			
		if player_y_accel > 0:
			bullet_instance.y_pos_offset *= -1
			
		bullet_instance.x_vector = -player_x_accel
		bullet_instance.y_vector = -player_y_accel
			
		get_parent().add_child(bullet_instance)

# handle enemy and kill box interactions
func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.get_parent().get_name() == "Enemey" && area.get_name() == "kill_box_area_2d"):
		restart(true)
		get_tree().reload_current_scene()
