extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.y += 5


func _on_area_2d_body_entered(body: Node2D) -> void:
	#print('uaghah55g')
	#print(body.name)
	if body.name == "bullet":
		set_process(true)
		#print('uaghah55g')
