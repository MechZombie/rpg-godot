extends Panel
@onready var button: Button = $MarginContainer/NinePatchRect/Button
@onready var animator: AnimatedSprite2D = $MarginContainer/NinePatchRect/AnimatedSprite2D

var player_hud = preload("res://Resources/HUD/player_hud.tres")

var animation: SpriteFrames

func _ready():
	print(animation)
	button.pressed.connect(on_select)
	animator.sprite_frames = animation
	
func on_select():
	print("clicou")
	player_hud.on_set_outfit(animation)
	
