extends Camera2D

@export var SCREEN_SIZE := Vector2( 320, 180 )
var cur_screen := Vector2(0, 0 )

@onready var timer = $"../Timer2"
@onready var cam = $"."

var waiting_for_timer = false
var p_zoom = 5

func _ready():
	set_as_top_level( true )
	if Singleton.camera_position == null:
		Singleton.camera_position = get_parent().global_position
	_update_screen( cur_screen )
	cam.zoom = Vector2(p_zoom, p_zoom)

func _physics_process(_delta):
	#print("global", global_position)
	var parent_screen: Vector2 = (get_parent().global_position / SCREEN_SIZE).floor()
	if not parent_screen.is_equal_approx( cur_screen ) and timer.is_stopped() and not waiting_for_timer:
		waiting_for_timer = true
		timer.start()
		
	if waiting_for_timer and timer.is_stopped():
		_update_screen(parent_screen)
		waiting_for_timer = false
			
func _update_screen( new_screen : Vector2 ):
	cur_screen = new_screen
	
	if Singleton.camera_restart:
		#Singleton.camera_position.y *= -1
		position_smoothing_enabled = false
		global_position = Singleton.camera_position
		await(get_tree().process_frame)
		position_smoothing_enabled = true
		Singleton.camera_restart = false
	else:
		Singleton.camera_position = (cur_screen * SCREEN_SIZE) + (SCREEN_SIZE * 0.5)
		
		global_position = Singleton.camera_position
