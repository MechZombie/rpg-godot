extends Area2D

@export var speed: float = 400.0
var direction: Vector2 = Vector2.ZERO

var target_id: int = 0
var damage: int = 0

func _ready():
	pass

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_spell_body_entered(body: Node) -> void:
	if body.is_in_group("Creatures") && body.info.id == target_id:
		body.on_show_hit(damage)
		body.update_health_bar()
		queue_free()
