extends Label

@export var duration := 1.0 
@export var float_speed := 20.0  
var lifetime := 0.0


func _process(delta: float) -> void:
	position.y -= float_speed * delta
	lifetime += delta
	if lifetime >= duration:
		queue_free()
