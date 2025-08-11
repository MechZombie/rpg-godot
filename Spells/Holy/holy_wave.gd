extends Area2D

@onready var area: Area2D = $"."
@onready var left: AnimatedSprite2D = $Left/AnimatedSprite2D
@onready var up: AnimatedSprite2D = $Up/AnimatedSprite2D
@onready var down: AnimatedSprite2D = $Down/AnimatedSprite2D
@onready var right: AnimatedSprite2D = $Right/AnimatedSprite2D
@onready var center: AnimatedSprite2D = $Center/AnimatedSprite2D
@onready var down_2: AnimatedSprite2D = $Down2/AnimatedSprite2D


var info = {
	"wave_min_damage": 5,
	"wave_max_damage": 10
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	
	left.play()
	up.play()
	down.play()
	down_2.play()
	right.play()
	center.play()
	
	await get_tree().create_timer(1).timeout
	queue_free()


func _process(delta: float) -> void:
	pass


func _on_body_entered(body):
	if body.is_in_group("Player"):
		var damage = randi_range(info.wave_min_damage, info.wave_max_damage)
		body.on_receive_damage(damage, Color.GOLD, -20)
