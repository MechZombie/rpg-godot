extends Area2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D2
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var speed: float = 400.0
var direction: Vector2 = Vector2.ZERO

var target_id: int = 0
var damage: int = 0

func _ready():
	anim.play()
	audio.play()
	audio.finished.connect(on_destroy)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func on_destroy():
	queue_free()
	
func _on_spell_body_entered(body: Node) -> void:
	if body.is_in_group("Creatures") && body.info.id == target_id:
		body.on_show_hit(damage, Color.RED)
		body.update_health_bar()
		visible = false
