extends Control

class_name Transitioner

@onready var text : TextureRect = $TextureRect
@onready var animation_player  = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	if Singleton.fade_out:
		set_next_animation()

func set_next_animation():
	animation_player.queue("fade_out")
	if animation_player.animation_finished:
		Singleton.fade_out = false
