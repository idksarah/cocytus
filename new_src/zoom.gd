extends Camera2D

func zoom():
	if Input.is_action_just_released('wheel_down'):
		set_zoom(get_zoom() - Vector2(0.25, 0.25))
	if Input.is_action_just_released('wheel_up'): #and get_zoom() > Vector2.ONE:
		set_zoom(get_zoom() + Vector2(0.25, 0.25))
