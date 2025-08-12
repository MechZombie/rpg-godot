extends Panel

@onready var cooldown: ColorRect = $Cooldown
@onready var timer: Timer = $Timer
@onready var label: Label = $MarginContainer/HBoxContainer/TextureButton/Label
@onready var texture_button: TextureButton = $MarginContainer/HBoxContainer/TextureButton

var target_height := 0
var increment := 4

var locked_time: float = 5.0
var decrement_per_second: float
var label_value: int
var has_cdr: bool
var texture

var cb: Callable


func _ready() -> void:
	texture_button.connect("pressed",Callable(self, "_on_button_pressed"))
	if(label_value):
		label.text = str(label_value)
	cooldown.visible = false
	
	if texture:
		texture_button.texture_normal = texture
	
func _on_button_pressed():
	if(not has_cdr and cb):
		cb.call()
		has_cdr = true
		cooldown.size.y = 40
		cooldown.visible = true
		decrement_per_second = cooldown.size.y / locked_time
		timer.wait_time = 1.0
		timer.start()
		timer.timeout.connect(_on_timer_timeout)
	
	
	
func _on_timer_timeout() -> void:
	if cooldown.size.y > target_height:
		cooldown.size.y = max(cooldown.size.y - decrement_per_second, target_height)
	else:
		timer.stop()
		has_cdr = false
