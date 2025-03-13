extends CharacterBody2D

@onready var animator = $AnimatedSprite2D
@onready var move_timer = $Timer
@onready var bullet = preload("res://Bullet.tscn")
@onready var landing_particles = preload("res://landing_particles.tscn")
@onready var leap_particles = preload("res://leap_particles.tscn")

var move_duration = 1

var mouse_pos : Vector2
var char_pos : Vector2

var cur_speed = 0.0
const reg_speed = 200.0
var x_direction_multiplier = 0.04
var y_direction_multiplier = 0.08
var min_x_accel = .1
var min_y_accel = .2
var max_x_accel = 1.2
var max_y_accel = 1.75
var max_x_input = 40
var max_y_input = 40

var cur_bullets_shot = 0
var max_bullets_shot = 1

@export var x_tolerance = 10
@export var y_tolerance = 0

var bullet_x_offset = 10
var bullet_y_offset = 10

var mouse_x_input := Input.get_axis("better_left", "better_right")
var mouse_y_input := Input.get_axis("better_down", "better_up")

enum state {left, right, down, up, left_down, left_up, right_down, right_up}
var current_state : state

var score = 0

var is_grounded = true

func _physics_process(delta: float) -> void:
	init(delta)
	track_mouse(delta)
	player_animations()
	move_and_slide()
	apply_gravity(delta)
	restart()
	player_shoot(delta)

	# Stop acceleration when the timer is not running
	if move_timer.is_stopped():
		#print('stap')
		velocity.x = lerp(velocity.x, 0.0, 0.2)
		velocity.y = lerp(velocity.y, 0.0, 0.2)

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
	if is_grounded == false and is_on_floor() == true:
		var landing_instance = landing_particles.instantiate()
		landing_instance.global_position = $Marker2D.global_position
		get_parent().add_child(landing_instance)
	elif is_grounded == true and is_on_floor() == false:
		var leap_instance = leap_particles.instantiate()
		leap_instance.global_position = $Marker2D.global_position
		get_parent().add_child(leap_instance)
	is_grounded = is_on_floor()
	
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

func player_shoot(_delta):
	if Input.is_action_pressed("shoot"):
		if is_on_floor():
			cur_bullets_shot = 0

		if is_on_floor() || cur_bullets_shot < max_bullets_shot:
			mouse_x_input = -(mouse_pos.x - char_pos.x)
			mouse_y_input = -(mouse_pos.y - char_pos.y)
				
			const acceleration = 1
			
			velocity.x = mouse_x_input * min(abs(velocity.x) + acceleration, max_x_accel)
			velocity.y = mouse_y_input * min(abs(velocity.y) + acceleration, max_y_accel)
			
			move_timer.wait_time = move_duration
			move_timer.start()
			
			#if not is_on_floor():
				#cur_bullets_shot+=1
			#
			## bullet
			#
			#var bullet_instance = bullet.instantiate() as Node2D
			#bullet_instance.pos = animator.global_position
			#
			#if player_x_accel > 0:
				#bullet_instance.x_pos_offset *= -1
				#
			#if player_y_accel > 0:
				#bullet_instance.y_pos_offset *= -1
				#
			#bullet_instance.x_vector = -player_x_accel
			#bullet_instance.y_vector = -player_y_accel
				#
				#get_parent().add_child(bullet_instance)
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.2)
	

# handle enemy and kill box interactions
func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.get_parent().get_name() == "Enemey" && area.get_name() == "kill_box_area_2d"):
		restart(true)
		get_tree().reload_current_scene()

func _on_timer_2_timeout() -> void:
	velocity = Vector2.ZERO
	print(velocity)
