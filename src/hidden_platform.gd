extends Node2D

@onready var platform_1_area = $Area2D
@onready var platform_2_area = $Area2D2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	platform_2_area.visible = false
	
func _on_area_2d_area_entered(_area: Area2D) -> void:
	platform_2_area.visible = true
