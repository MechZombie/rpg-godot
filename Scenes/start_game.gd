extends Node2D
@onready var start_button: Button = $CanvasLayer/MarginContainer/HBoxContainer/Control/NinePatchRect/VBoxContainer/MarginContainer/MenuButton

func _ready() -> void:
	start_button.pressed.connect(on_start_pressed)


func on_start_pressed():
	get_tree().change_scene_to_file("res://Maps/Cave/cave.tscn")
