extends CharacterBody2D

@onready var animator = $AnimatedSprite2D
@onready var move_timer = $Timer
@onready var bullet = preload("res://Bullet.tscn")
@onready var landing_particles = preload("res://landing_particles.tscn")
@onready var leap_particles = preload("res://leap_particles.tscn")
@onready var muzzle = $Muzzle

var mouse_pos : Vector2
var char_pos : Vector2
var move_timer_duration = .3

var vel_multipler = 120
var max_x_accel = 1.25
var max_y_accel = 1.25
var max_x_input = 40
var max_y_input = 40
var gravity := 200
var fall_gravity := 400

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
@export var can_shoot = true
var can_glide = false
var start_timer = true
var fly_boost = false
var fly_boost_animation = false
var is_grounded = true
var was_gliding = false
@export var gravity_on = true

func _physics_process(delta: float) -> void:
	track_mouse()
	player_animations()
	move_and_slide()
	apply_gravity(delta)
	handle_restart()
	var is_shooting = player_shoot()
	
	if not is_shooting:
		player_glide()    
	velocity.x *= 0.95
	
func _ready():
	global_position = Singleton.last_checkpoint

func handle_restart(p_restart = false):
	if(Input.is_action_just_pressed("restart") or p_restart):
		Singleton.reset()

func apply_gravity(delta):
	if gravity_on:
		velocity.y += get_jump_gravity() * delta
		
		if not is_on_floor():
			velocity += get_gravity() * delta * 0.7

func get_jump_gravity():
	if velocity.y < 0:
		return gravity
	else:
		return fall_gravity
		
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
	
	if not fly_boost and is_on_floor():
		fly_boost_animation = false
	
	if(fly_boost_animation) and not is_on_floor():
		match current_state:
			state.left: animator.play("boost_left")
			state.left_up: animator.play("boost_left_up")
			state.left_down: animator.play("boost_left_down")
			state.right: animator.play("boost_right")
			state.right_up: animator.play("boost_right_up")
			state.right_down: animator.play("boost_right_down")
			state.up: animator.play("boost_up")
			state.down: animator.play("boost_down")
	else:
		match current_state:
			state.left: animator.play("left")
			state.left_up: animator.play("left_up")
			state.left_down: animator.play("left_down")
			state.right: animator.play("right")
			state.right_up: animator.play("right_up")
			state.right_down: animator.play("right_down")
			state.up: animator.play("up")
			state.down: animator.play("down")

func track_mouse():
	mouse_pos = get_global_mouse_position()
	char_pos = global_position
	
	var x_diff = mouse_pos.x - char_pos.x
	var y_diff = mouse_pos.y - char_pos.y

	if abs(x_diff) > x_tolerance:
		if x_diff < 0:
			if y_diff > y_tolerance:
				current_state = state.left_down
			elif y_diff < -y_tolerance:
				current_state = state.left_up
			else:
				current_state = state.left
		else:
			if y_diff > y_tolerance:
				current_state = state.right_down
			elif y_diff < -y_tolerance:
				current_state = state.right_up
			else:
				current_state = state.right
	else:
		if y_diff < -y_tolerance:
			current_state = state.up
		elif y_diff > y_tolerance:
			current_state = state.down

func apply_boost():	
	if fly_boost:
		can_shoot = true
		fly_boost = false
		fly_boost_animation = true
		start_timer = true

func player_shoot():
	if Input.is_action_pressed("shoot"):
		apply_boost()
		if can_shoot:
			if start_timer:
				move_timer.wait_time = move_timer_duration
				move_timer.start()
				start_timer = false
				
			const acceleration = 1.5
			
			var direction = (char_pos - mouse_pos).normalized()
			
			if Input.is_action_pressed("glide"):
				velocity.x = vel_multipler * direction.x * min(abs(velocity.x) + acceleration, max_x_accel) / 0.5
				velocity.y = vel_multipler * direction.y * min(abs(velocity.y) + acceleration, max_y_accel) / 0.25
				was_gliding = false
			else:	
				velocity.x = vel_multipler * direction.x * min(abs(velocity.x) + acceleration, max_x_accel)
				velocity.y = 1.2 * vel_multipler * direction.y * min(abs(velocity.y) + acceleration, max_y_accel)
				
				# bullet
				muzzle.shoot(direction.x, direction.y)
				
		else:			
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			velocity.y = lerp(velocity.y, 0.0, 0.2)
	if is_on_floor():
		can_shoot = true
		start_timer = true
	else:
		can_glide = true

func player_glide():
	if Input.is_action_pressed("glide"):
		apply_boost()
		if can_glide:
			was_gliding = true
			var direction = (char_pos - mouse_pos).normalized()
					
			const acceleration = 1
				
			velocity.x = 0.5 * vel_multipler * direction.x * min(abs(velocity.x) + acceleration, max_x_accel)
			velocity.y = 0.4 * vel_multipler * min(abs(velocity.y) + acceleration, max_y_accel)
			
# handle enemy and kill box interactions
func _on_area_2d_area_entered(area: Area2D) -> void:
	if(area.get_parent().get_name() == "Enemey" && area.get_name() == "kill_box_area_2d"):
		Singleton.reset()
		Singleton.kill_player()

func _on_timer_timeout() -> void:
	can_shoot = false
