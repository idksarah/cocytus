extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -300.0
var doubleJumpAllowed = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		doubleJumpAllowed = true
		
	# double jump
	if Input.is_action_just_pressed("ui_accept") and !is_on_floor():
		if doubleJumpAllowed:
			velocity.y = JUMP_VELOCITY
			doubleJumpAllowed = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("betterLeft", "betterRight")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
		
