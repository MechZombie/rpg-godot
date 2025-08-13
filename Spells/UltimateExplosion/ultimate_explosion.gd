extends Area2D


@export var speed: float = 400.0

@onready var control: Control = $Control
var target_hits = []
var damage
var target_id

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for fire in control.get_children():
		fire.body_entered.connect(_on_body_entered)
		fire.get_node("AnimatedSprite2D").play()

	await get_tree().create_timer(1).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body):
	if not body.is_in_group("Creatures"):
		return
		
	if(body.info.id not in target_hits):
			target_hits.append(body.info.id)
			body.on_show_hit(damage, Color.ORANGE)
