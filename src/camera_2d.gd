extends Camera2D


const SCREEN_SIZE := Vector2( 1600, 900 )
var cur_screen := Vector2( 0, 0 )
@onready var timer = $"../Timer2"

var down_offset = 0
var waiting_for_timer = false

func _ready():
	set_as_top_level( true )
	global_position = get_parent().global_position
	_update_screen( cur_screen )

func _physics_process(_delta):
	var parent_screen : Vector2 = ( get_parent().global_position / SCREEN_SIZE ).floor()
	
	if not parent_screen.is_equal_approx( cur_screen ) and timer.is_stopped() and not waiting_for_timer:
		waiting_for_timer = true
		timer.start()
		
	if waiting_for_timer and timer.is_stopped():
		_update_screen(parent_screen)
		waiting_for_timer = false
			
func _update_screen( new_screen : Vector2 ):
	cur_screen = new_screen
	global_position = cur_screen * SCREEN_SIZE + SCREEN_SIZE * 0.5
	global_position.y += down_offset
