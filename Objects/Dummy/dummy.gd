extends CharacterBody2D
const FloatingText = preload("res://Objects/Hit/hit_damage.tscn")


@onready var anim = $AnimatedSprite2D
@onready var health_bar_foreground = $Control/Foreground
@onready var health_bar_backeground = $Control/Background
@onready var target = $Target

@export var tile_size := Vector2(32, 32)

var speed = 5.0
const JUMP_VELOCITY = -400.0
var min_distance_in_tiles = 1

var is_moving = false
var move_to_position = Vector2.ZERO
var direction = Vector2.ZERO

var info := {
	"id": 1,
	"def": 3
}

var max_health := 100
var current_health := 100

var is_target: bool = false
var dmg_label = null
var atk_timer: Timer = null 

func _ready() -> void:
	target.visible = false
	update_health_bar()

func _physics_process(delta: float) -> void:
	pass
		
func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var player = get_parent().get_node("Player")
		player.clear_target()
		
		var cav = get_parent()
		var dummies = cav.creature_instances
		
		for dummy in dummies:
			if(dummy.info.id != info.id):
				dummy.is_target = false
				dummy.target.visible = false
		
		is_target = !is_target
		target.visible = is_target
		
		player.has_target = is_target
		player.target_id = info.id
		player.on_atk()


func on_show_hit(damage):
	dmg_label = FloatingText.instantiate()
	dmg_label.text = "-" + str(damage)
	dmg_label.global_position = global_position + Vector2(0, -55)  
	current_health -= damage
	get_tree().current_scene.add_child(dmg_label)
	

func update_health_bar():
	if(current_health <= 0):
		current_health = 100
		
	var percent: float = float(current_health) / float(max_health)
	var full_width: float = health_bar_backeground.size.x  
	health_bar_foreground.size.x = full_width * percent

func on_verify_player(delta):
	var player = get_parent().get_node("Player")
	if not player:
		return

	var distance = global_position.distance_to(player.position)
	var distance_in_tiles = Vector2(
		abs(player.position.x - global_position.x) / tile_size.x,
		abs(player.position.y - global_position.y) / tile_size.y
	)

	# Se a distância em tiles for maior que o mínimo (em qualquer direção)
	if distance_in_tiles.length() > min_distance_in_tiles:
		var dir = (player.position - global_position).normalized()

		# Direção dominante (X ou Y)
		var direction := Vector2.ZERO
		if abs(dir.x) > abs(dir.y):
			direction = Vector2(sign(dir.x), 0)
		else:
			direction = Vector2(0, sign(dir.y))

		# Define próximo destino
		var offset = Vector2(direction.x * tile_size.x, direction.y * tile_size.y)
		var next_position = global_position + offset
		var velocity = direction * speed * delta

		var collision = move_and_collide(velocity)
		print(collision)

		move_to_position = next_position
		is_moving = true
		move_and_collide(velocity)



func is_tile_blocked(position: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var point_params = PhysicsPointQueryParameters2D.new()
	point_params.position = position
	point_params.collide_with_areas = true
	point_params.collide_with_bodies = true
	
	var result = space_state.intersect_point(point_params)

	for res in result:
		print(res.collider)
		if res.collider.is_in_group("Creatures"):
			return true

	return false
