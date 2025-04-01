extends Control

@onready var text : TextureRect = $TextureRect
@onready var animation_player  = $AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text.visible = false

func _process(_delta: float) -> void:
	if Singleton.fade_in:
		set_next_animation()

func set_next_animation():
	animation_player.queue("fade_in")
	if animation_player.animation_finished:
		Singleton.fade_in = false
