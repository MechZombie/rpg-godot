extends Control

@onready var button: Button = $Panel/NinePatchRect/Button
var cb: Callable

func _ready():
	button.pressed.connect(on_rebirth)
	
	
func on_rebirth():
	if cb:
		cb.call()
