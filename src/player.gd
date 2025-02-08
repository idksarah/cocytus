extends CharacterBody2D

const reg_speed = 300.0
const giga_speed = 400.0
const jump_velocity = -800.0
const coyote_time = 0.2

var doubleJumpAllowed = true
var mousePos : Vector2
var charPos : Vector2
var move_duration = 0.1
var giga_move_duration = 0.15
var move_timer = 0.0
var cur_speed = 0.0
var left_right_time_held = 0.0
var left_right_held = false
var curr_coyote_time = 0

var x_tolerance = 30
var y_tolerance = 40
var x_direction_multiplier = 0.015
var y_direction_multiplier = 0.015
var max_x_direction = 3
var max_y_direction = 2.5
#var leftLastHeld = false;

@onready var animator = $AnimatedSprite2D

enum state {left_shoot, right_shoot, down_shoot, up_shoot, left_down_shoot, left_up_shoot, right_down_shoot, right_up_shoot}
var current_state : state

func _physics_process(delta: float) -> void:
	player_init(delta)
	track_mouse(delta)
	#player_shoot(delta)
	player_animations()
		
	move_and_slide()
	
func player_init(delta):
	# Add gravity
	if not is_on_floor():
		velocity += 2 * get_gravity() * delta

func player_animations():
	if current_state == state.left_shoot:
		animator.play("left_shoot")
	elif current_state == state.right_shoot:
		animator.play("right_shoot")

func track_mouse(delta):
	mousePos = get_global_mouse_position()
	charPos = global_position
	#print(mousePos)
	#print(charPos)
	if(mousePos.x < charPos.x && abs(mousePos.x - charPos.x) > x_tolerance):
		if(mousePos.y < charPos.y - y_tolerance ):
			current_state = state.left_down_shoot
			#print("left up")
		elif(mousePos.y > charPos.y + y_tolerance):
			current_state = state.left_up_shoot
			#print("left down")
		else:
			current_state = state.left_shoot
			#print("left")
	elif(mousePos.x > charPos.x && abs(mousePos.x - charPos.x) > x_tolerance):
		if(mousePos.y < charPos.y - y_tolerance):
			current_state = state.right_down_shoot
			#print("right up")
		elif(mousePos.y > charPos.y + y_tolerance):
			current_state = state.right_up_shoot
			#print("right down")
		else:
			current_state = state.right_shoot
			#print("right")
	else:
		if(mousePos.y < charPos.y - y_tolerance):
			current_state = state.right_down_shoot
			#print("up")
		elif(mousePos.y > charPos.y + y_tolerance):
			current_state = state.right_up_shoot
			#print("down")
	
	if(Input.is_action_just_pressed("shoot")):
		player_shoot(delta)
	# continue moving for move_duration even after player releases key
	elif move_timer > 0:
		move_timer-= delta
	else:
		velocity.x = move_toward(velocity.x, 0, reg_speed)

func player_shoot(delta):
		
	var x_direction := Input.get_axis("better_left", "better_right")
	var y_direction := Input.get_axis("better_down", "better_up")
	
	if(Input.is_action_just_pressed("shoot")):
		x_direction = -(mousePos.x - charPos.x) * x_direction_multiplier
		y_direction = -(mousePos.y - charPos.y) * y_direction_multiplier
			
		x_direction = clamp(x_direction, -max_x_direction, max_x_direction)
		y_direction = clamp(y_direction, -max_y_direction, max_y_direction)
		
		velocity.x = x_direction * reg_speed
		velocity.y = y_direction * reg_speed
		move_timer = move_duration
			
