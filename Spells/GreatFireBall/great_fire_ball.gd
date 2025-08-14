extends Area2D

@onready var leftArea: Area2D = $Control/Left
@onready var centerArea: Area2D = $Control/Center
@onready var rightArea: Area2D = $Control/Right
@onready var downArea: Area2D = $Control/Down
@onready var upArea: Area2D = $Control/Up
@onready var shoot: Area2D = $Shoot
@onready var control: Control = $Control


var direction: Vector2 = Vector2.ZERO
@export var speed: float = 400.0

var target_id: int = 0
var target_position: Vector2
var damage: float
var is_moving: bool = true

var target_hits = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	control.visible = false
	
	leftArea.body_entered.connect(_on_body_explode_entered)
	upArea.body_entered.connect(_on_body_explode_entered)
	downArea.body_entered.connect(_on_body_explode_entered)
	rightArea.body_entered.connect(_on_body_explode_entered)
	centerArea.body_entered.connect(_on_body_explode_entered)
	
	shoot.body_entered.connect(_on_body_shoot_entered)
	
	on_shoot()
	
	
func _physics_process(delta: float) -> void:
	if is_moving:
		position += direction * speed * delta

func on_shoot():
	shoot.get_node("AnimatedSprite2D").play()
	

func on_explode():
	control.visible = true
	
	leftArea.get_node('AnimatedSprite2D').play()
	upArea.get_node('AnimatedSprite2D').play()
	downArea.get_node('AnimatedSprite2D').play()
	rightArea.get_node('AnimatedSprite2D').play()
	centerArea.get_node('AnimatedSprite2D').play()
	
	await get_tree().create_timer(1).timeout
	queue_free()
	

func _on_body_shoot_entered(body):
	if body.is_in_group("Creatures"):
		shoot.visible = false
		is_moving = false
		on_explode()
		
func _on_body_explode_entered(body):
	if not body.is_in_group("Creatures"):
		return
		
	if(body.info.id not in target_hits):
			target_hits.append(body.info.id)
			body.on_show_hit(damage, Color.ORANGE)
			body.update_health_bar()
