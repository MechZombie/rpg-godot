extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var area_2d: Area2D = $Area2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D




func _ready():
	anim.play("default")
	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pass
		
	
