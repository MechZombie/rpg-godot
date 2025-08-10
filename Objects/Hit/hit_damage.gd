extends Label

@export var duration := 1.0 
@export var float_speed := 20.0  
var lifetime := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	position.y -= float_speed * delta
	lifetime += delta
	if lifetime >= duration:
		queue_free()

func _on_auto_delete_timer_timeout():
	queue_free()
