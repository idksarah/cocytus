extends Area2D

@onready var player = self.get_parent().get_parent().get_parent().get_node("Player")
@onready var timer = $Timer

@onready var top = $Top
@onready var bottom = $Bottom

var in_out = false
var should_start_timer = true
var wait_time = .1
var deltaXY = Vector2(0,0)

func _ready():
	var top = top.global_position
	var bottom = bottom.global_position
	deltaXY.y = -(top.y - bottom.y)
	deltaXY.x = (top.x - bottom.x)
	deltaXY = deltaXY.normalized()
	#print(deltaXY)
	set_process(false)
	
func _process(delta: float) -> void:
	if deltaXY.x == 0:
		player.velocity.y -= 15
	else:
		player.velocity.y -=  deltaXY.y * 25
		player.velocity.x += deltaXY.x * 25
		player.gravity_on = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player.in_wind = true
		set_process(true)
		player.can_shoot = true
		
func _on_body_exited(_body: Node2D) -> void:
	player.in_wind = false
	
	set_process(false)
	if deltaXY.x == 0:
		player.velocity.y += 15
	else:
		player.velocity.y +=  deltaXY.y * 25
		player.velocity.y -= deltaXY.x * 25
	
	player.gravity_on = true
	
func _on_in_out_body_entered(body: Node2D) -> void:
		if body.is_in_group("Player"):
			#print('kinda in wind')
			player.kinda_in_wind = true

func _on_in_out_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		#print('not kinda in wind')
		player.kinda_in_wind = false
 
