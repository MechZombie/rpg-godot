extends CharacterBody2D

const FloatingText = preload("res://Objects/hit_damage.tscn")


const SPEED = 50.0
@export var tile_size := 32


var player: Node2D
var target_position: Vector2
var is_moving = false

var max_health := 100
var current_health := 100

var is_target: bool = false
var dmg_label = null

@onready var ray_down = $RayCastDown
@onready var ray_up = $RayCastUp
@onready var ray_left = $RayCastLeft
@onready var ray_right = $RayCastRight

@onready var health_bar_foreground = $Control/Foreground
@onready var health_bar_backeground = $Control/Background

@onready var target = $Target

var info := {
	"id": 1,
	"def": 3
}

func _ready() -> void:
	target.visible = false
	update_health_bar()

func on_detect_player():
	player = get_parent().get_node("Player")
	if(!player):
		return
		
	# calcular vetor até o player
	var diff = player.global_position - global_position
	var input_vector = Vector2.ZERO

	# prioriza eixo X, depois Y
	if abs(diff.x) > abs(diff.y):
		input_vector.x = sign(diff.x)
	else:
		input_vector.y = sign(diff.y)

	var ray = get_ray_for_direction(input_vector)
		
	if input_vector != Vector2.ZERO and ray and not ray.is_colliding():
		target_position = global_position + input_vector * tile_size
		is_moving = true

func _physics_process(delta: float) -> void:
	var player = get_node("Player")
	
	if is_moving:
		var direction = (target_position - global_position).normalized()
		var distance = SPEED * delta
		var to_target = target_position - global_position

		if to_target.length() <= distance:
			global_position = target_position
			is_moving = false
		else:
			velocity = direction * SPEED
			move_and_slide()
	else:
		on_detect_player()


func get_ray_for_direction(direction: Vector2) -> RayCast2D:
	if direction == Vector2.RIGHT:
		return ray_right
	elif direction == Vector2.LEFT:
		return ray_left
	elif direction == Vector2.UP:
		return ray_up
	elif direction == Vector2.DOWN:
		return ray_down
	return null


func update_health_bar():
	if(current_health <= 0):
		current_health = 100
		
	var percent: float = float(current_health) / float(max_health)
	var full_width: float = health_bar_backeground.size.x  
	health_bar_foreground.size.x = full_width * percent

func on_show_hit(damage):
	dmg_label = FloatingText.instantiate()
	dmg_label.text = "-" + str(damage)
	dmg_label.global_position = global_position + Vector2(0, -55)  
	current_health -= damage
	get_tree().current_scene.add_child(dmg_label)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var player = get_parent().get_node("Player")
		player.clear_target()
		
		var cav = get_parent()
		var dummies = cav.dummy_instances
		
		for dummy in dummies:
			if(dummy.info.id != info.id):
				dummy.is_target = false
				dummy.target.visible = false
		
		is_target = !is_target
		target.visible = is_target
		
		player.has_target = is_target
		player.on_atk(global_position, info.id)
