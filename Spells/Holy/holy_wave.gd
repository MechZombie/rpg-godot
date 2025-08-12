extends Area2D

@onready var area: Area2D = $"."
@onready var left: AnimatedSprite2D = $Wave/Left/AnimatedSprite2D
@onready var up: AnimatedSprite2D = $Wave/Up/AnimatedSprite2D
@onready var down: AnimatedSprite2D = $Wave/Down/AnimatedSprite2D
@onready var right: AnimatedSprite2D = $Wave/Right/AnimatedSprite2D
@onready var center: AnimatedSprite2D = $Wave/Center/AnimatedSprite2D
@onready var down_2: AnimatedSprite2D = $Wave/Down2/AnimatedSprite2D

@onready var wave: Control = $Wave

@onready var leftArea: Area2D = $Wave/Left
@onready var upArea: Area2D = $Wave/Up
@onready var downArea: Area2D = $Wave/Down
@onready var rightArea: Area2D = $Wave/Right
@onready var centerArea: Area2D = $Wave/Center
@onready var down_2Area: Area2D = $Wave/Down2



var info = {
	"wave_min_damage": 5,
	"wave_max_damage": 10
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	leftArea.body_entered.connect(_on_body_entered)
	upArea.body_entered.connect(_on_body_entered)
	downArea.body_entered.connect(_on_body_entered)
	rightArea.body_entered.connect(_on_body_entered)
	centerArea.body_entered.connect(_on_body_entered)
	down_2Area.body_entered.connect(_on_body_entered)
	
	
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
	print("tome")
	if body.is_in_group("Player"):
		var damage = randi_range(info.wave_min_damage, info.wave_max_damage)
		body.on_receive_damage(damage, Color.GOLD, -20)
