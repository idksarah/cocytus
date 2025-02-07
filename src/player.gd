extends CharacterBody2D

const reg_speed = 300.0
const giga_speed = 400.0
const jump_velocity = -800.0
const coyote_time = 0.2

var doubleJumpAllowed = true
#var mousePos : Vector2
var move_duration = 0.1
var giga_move_duration = 0.15
var move_timer = 0.0
var cur_speed = 0.0
var left_right_time_held = 0.0
var left_right_held = false
var curr_coyote_time = 0
#var leftLastHeld = false;

@onready var animator = $AnimatedSprite2D

enum state {left_shoot, right_shoot, down_shoot, up_shoot, left_down_shoot, left_up_shoot, right_down_shoot, right_up_shoot}
var current_state : state

func _physics_process(delta: float) -> void:
	player_init(delta)
	player_shoot(delta)
	player_animations()
	#player_jump(delta)
		
	move_and_slide()
	
func player_init(delta):
	# Add gravity
	if not is_on_floor():
		velocity += 2 * get_gravity() * delta
		curr_coyote_time-=delta

func player_jump(delta):
	if is_on_floor():
		curr_coyote_time = coyote_time

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and curr_coyote_time >= 0:
		velocity.y = jump_velocity
		doubleJumpAllowed = true

func player_animations():
	if current_state == state.left_shoot:
		animator.play("left_shoot")
	elif current_state == state.right_shoot:
		animator.play("right_shoot")
	#if current_state == state.down_shoot:
		#print("bleh")

func player_shoot(delta):
	if(Input.is_action_just_pressed("better_left")):
		current_state = state.left_shoot
	elif(Input.is_action_just_pressed("better_right")):
		current_state = state.right_shoot
	elif(Input.is_action_just_pressed("better_down")):
		current_state = state.down_shoot
	elif(Input.is_action_just_pressed("better_up")):
		current_state = state.up_shoot
		
	var x_direction := Input.get_axis("better_left", "better_right")
	var y_direction := Input.get_axis("better_down", "better_up")
	
	##go faster if key held
	#if x_direction != 0:
		#if not left_right_held:
				#left_right_time_held = 0
				#left_right_held = true
		#left_right_time_held += delta
	#else:
		#left_right_held = false
		#left_right_time_held = 0
		
	if(Input.is_action_just_pressed("shoot")):
		if(current_state == state.left_shoot):
			x_direction = 1
			y_direction = 0
		elif(current_state == state.right_shoot):
			x_direction = -1
			y_direction = 0
		elif(current_state == state.down_shoot):
			x_direction = 0
			y_direction = 1
		elif(current_state == state.up_shoot):
			x_direction = 0
			y_direction = -1
			
		velocity.x = x_direction * reg_speed
		velocity.y = y_direction * 1.7 * reg_speed
		
		move_timer = move_duration
		
		print(left_right_time_held)
		#if(x_direction != 0 && left_right_time_held > 0.5):
			#velocity.x = x_direction * giga_speed
			##velocity.x = -direction * reg_speed
			##move_timer += delta
		##else:
			#velocity.x = x_direction * reg_speed
	# continue moving for move_duration even after player releases key
	elif move_timer > 0:
		move_timer-= delta
	else:
		velocity.x = move_toward(velocity.x, 0, reg_speed)
