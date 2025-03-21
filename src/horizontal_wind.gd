extends Area2D

@onready var player = self.get_parent().get_parent().get_parent().get_node("Player")
@onready var timer = $Timer

var get_out = false
var should_start_timer = true
var wait_time = .1

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	player.velocity.x = lerp(player.velocity.x, 200.0, delta)  # Smooth transition
	player.can_shoot = true
		

func _on_body_entered(body: Node2D) -> void:
	get_out = false
	if body.is_in_group("Player"):
		set_process(true)
		
func _on_body_exited(_body: Node2D) -> void:
	set_process(false)
