extends Control

@onready var button: Button = $Panel/NinePatchRect/NinePatchRect/NinePatchRect/Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.pressed.connect(on_start_pressed)


func on_start_pressed():
	get_tree().change_scene_to_file("res://Maps/Cave/cave.tscn")
