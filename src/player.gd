extends CharacterBody2D

#const camera = preload("./camera.gd").new()

const SPEED = 300.0
const JUMP_VELOCITY = -500.0
var doubleJumpAllowed = true
var mousePos : Vector2
var centerPos : Vector2
@onready var character = get_node("Player")

func _physics_process(delta: float) -> void:
	_tongue()
	
	# Add gravity
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

	var direction := Input.get_axis("betterLeft", "betterRight")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
		
func _tongue() -> void:
	#_draw(Vector2(1,1))
	var leftMousePressed = false
	var waitTime = 0.25
	var line : Line2D
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)):
		leftMousePressed = true
	if(Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)):
		leftMousePressed = true
	await get_tree().create_timer(waitTime).timeout
	if(leftMousePressed == true):
		mousePos = to_local(get_global_mouse_position())
		centerPos = Vector2(10,10)
		print(mousePos)
		queue_redraw()
		

func _draw() -> void:
	draw_line(centerPos, mousePos, Color.PINK, 8.0)
