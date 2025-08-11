extends CharacterBody2D

const FloatingText = preload("res://Objects/Hit/hit_damage.tscn")

@export var HolyWave: PackedScene
@export var tile_size := 32


@onready var wave: Control = $Wave

var speed = 40.0

var push_force := 200.0
var push_vector := Vector2.ZERO
var push_time := 0.15
var push_timer := 0.0

var player: Node2D
var target_position: Vector2
var is_moving = false

var max_health := 100
var current_health := 100
signal health_changed(new_health)

var last_direction := Vector2.DOWN # direção padrão inicial


var is_target: bool = false
var dmg_label = null

@onready var ray_down = $RayCastDown
@onready var ray_up = $RayCastUp
@onready var ray_left = $RayCastLeft
@onready var ray_right = $RayCastRight

@onready var health_bar_foreground = $Control/Foreground
@onready var health_bar_backeground = $Control/Background

@onready var agent: NavigationAgent2D

@onready var target = $Target

var atk_timer: Timer

var astar_grid := AStarGrid2D.new()

var info := {
	"id": 1,
	"def": 3,
	"atk_min": 2,
	"atk_max": 5,
	"atk_range": 70,
	"wave_rng": [0,3]
}



func _ready() -> void:
	target.visible = false
	
	player = get_parent().get_node("Player")
	agent = get_node("NavigationAgent2D")
	
	agent.avoidance_enabled = true
	agent.radius = 31.9  # Ajuste de acordo com o tamanho do seu CollisionShape2D
	agent.max_speed = speed
	
	atk_timer = Timer.new()
	atk_timer.wait_time = 2.0
	atk_timer.one_shot = false
	atk_timer.connect("timeout", Callable(self, "on_calculate_damage"))
	add_child(atk_timer)
	atk_timer.start()
	
	
func on_call_spell():
	var holy_wave = HolyWave.instantiate()
	holy_wave.global_position = global_position
	get_parent().add_child(holy_wave)

func _physics_process(delta):
	if push_timer > 0:
		push_timer -= delta
		velocity = push_vector
		move_and_slide()
		return
		
	if not player:
		return
		
	var direction_player = (player.global_position - global_position).normalized()
	var target_side = player.global_position - (direction_player * 32)

	agent.target_position = target_side
	

	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		if abs(last_direction.x) > abs(last_direction.y):
			if last_direction.x > 0:
				$AnimatedSprite2D.play("idle_right")
			else:
				$AnimatedSprite2D.play("idle_left")
		else:
			if last_direction.y > 0:
				$AnimatedSprite2D.play("idle_up")
			else:
				$AnimatedSprite2D.play("idle_up")
	else:
		var next_position = agent.get_next_path_position()
		var direction = (next_position - global_position).normalized()
		velocity = direction * speed
		
		last_direction = direction
		print(direction)
		
		if abs(direction.x) > abs(direction.y):
			if direction.x > 0:
				$AnimatedSprite2D.play("walk_right")
			else:
				$AnimatedSprite2D.play("walk_left")
		else:
			if direction.y > 0:
				$AnimatedSprite2D.play("walk_down")
			else:
				$AnimatedSprite2D.play("walk_up")
				
		move_and_slide()
		
	

func apply_pushback(from_position: Vector2):
	push_vector = (global_position - from_position).normalized() * push_force
	push_timer = push_time

func on_detect_player():
	player = get_parent().get_node("Player")
	if not player:
		return

	var diff = player.global_position - global_position
	var input_vector = Vector2.ZERO

	# Prioriza X
	if abs(diff.x) > abs(diff.y):
		input_vector = Vector2(sign(diff.x), 0)
	else:
		input_vector = Vector2(0, sign(diff.y))

	var ray = get_ray_for_direction(input_vector)
	
	if ray and not ray.is_colliding():
		target_position = global_position + input_vector 
		is_moving = true

	
func on_calculate_damage():
	if global_position.distance_to(player.global_position) <= info.atk_range:
		var atk = randi_range(info.atk_min, info.atk_max)
		player.on_receive_damage(atk, Color.RED, 0)
	
	var spell_random = randi_range(info.wave_rng[0], info.wave_rng[1])
	print(spell_random)
	if spell_random == 1:
		on_call_spell()
		
	

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
	var cav = get_parent()
	
	if(current_health <= 0):
		cav.spawn_creature()
		player.clear_target()
		queue_free()
		
	var percent: float = float(current_health) / float(max_health)
	var HUD = player.get_node("HUD")
	HUD.set_enemy_health(percent)


func on_show_hit(damage, color: Color):
	dmg_label = FloatingText.instantiate()
	dmg_label.text = "-" + str(damage)
	dmg_label.global_position = global_position + Vector2(0, -35)  
	current_health -= damage
	
	dmg_label.label_settings = dmg_label.label_settings.duplicate() # cria cópia
	dmg_label.label_settings.font_color = color
	
	get_tree().current_scene.add_child(dmg_label)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var player = get_parent().get_node("Player")
		player.clear_target()
		
		var cav = get_parent()
		var dummies = cav.creature_instances
		
		for dummy in dummies:
			if(is_instance_valid(dummy) and dummy.info.id != info.id):
				dummy.is_target = false
				dummy.target.visible = false
		
		is_target = !is_target
		target.visible = is_target
		
		player.has_target = is_target
		player.target_id = info.id
		player.enemy_life_bar.visible = is_target
		
		var percent: float = float(current_health) / float(max_health)
		var HUD = player.get_node("HUD")
		HUD.set_enemy_health(percent)

		player.on_atk()
