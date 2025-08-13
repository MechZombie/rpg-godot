extends CollisionShape2D

@onready var anim = $AnimatedSprite2D
@onready var timer = $Timer
@onready var light = $PointLight2D

var grow = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play('default')
	timer.wait_time = 1.5
	timer.timeout.connect(_on_timer_timeout)
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
func _on_timer_timeout():
	# Alterna entre crescer e diminuir
	if grow:
		light.texture_scale += 0.2
	else:
		light.texture_scale -= 0.2
	
	grow = !grow
