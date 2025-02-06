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

enum state {left_shoot, right_shoot}
var current_state : state

func _physics_process(delta: float) -> void:
	player_shoot(delta)
	player_animations()
	player_jump(delta)
		
	move_and_slide()
	
func player_jump(delta):
	# Add gravity
	if not is_on_floor():
		velocity += 2 * get_gravity() * delta
		curr_coyote_time-=delta
		
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

func player_shoot(delta):
	if(Input.is_action_just_pressed("betterLeft")):
		current_state = state.left_shoot
	if(Input.is_action_just_pressed("betterRight")):
		current_state = state.right_shoot
		
	var direction := Input.get_axis("betterLeft", "betterRight")
	#go faster if key held
	if direction != 0:
		if not left_right_held:
				left_right_time_held = 0
				left_right_held = true
		left_right_time_held += delta
	else:
		left_right_held = false
		left_right_time_held = 0
		
	if direction:
		#print(move_timer)
		if(left_right_held && left_right_time_held > 0.5):
			#velocity.x = -direction * giga_speed
			#velocity.x = -direction * reg_speed
			move_timer = giga_move_duration
		else:
			velocity.x = -direction * reg_speed
			move_timer = move_duration
	# continue moving for move_duration even after player releases key
	elif move_timer > 0:
		move_timer-= delta
	else:
		velocity.x = move_toward(velocity.x, 0, reg_speed)
