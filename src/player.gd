extends CharacterBody2D

#const camera = preload("./camera.gd").new()

const reg_speed = 300.0
const giga_speed = 400.0
const jump_velocity = -500.0

var doubleJumpAllowed = true
#var mousePos : Vector2
var move_duration = 0.07
var giga_move_duration = 0.15
var move_timer = 0.0
var cur_speed = 0.0
var left_right_time_held = 0.0
var left_right_held = false
#var leftLastHeld = false;

#@onready var character = get_node("../Player")

enum state {left_shoot, right_shoot}
var current_state : state

func _physics_process(delta: float) -> void:
	#print(character[0].name)
	player_shoot()
	#player_animations()
	
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		doubleJumpAllowed = true
		
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

	move_and_slide()

#func player_animations():
	#if current_state == state.left_shoot:
		#character.play("left_shoot")
	#elif current_state == state.right_shoot:
		#character.play("right_shoot")

func player_shoot():
	if(Input.is_action_just_pressed("shoot")):
		if(Input.is_action_just_pressed("betterLeft")):
			current_state = state.left_shoot
			#leftLastHeld = true
		if(Input.is_action_just_pressed("betterRight")):
			current_state = state.right_shoot
			#leftLastHeld = false
	
