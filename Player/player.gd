extends CharacterBody2D

const SPEED = 100
@export var SpellScene: PackedScene


@export var tile_size := Vector2(32,32)
@onready var spell = $Spell
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var anim = $AnimatedSprite2D
@onready var health_bar_foreground = $Control/Foreground
@onready var health_bar_backeground = $Control/Background
@onready var target = $Target


var info := {
	"id": 1,
	"atk_min": 5,
	"atk_max": 10,
	"range": 3
}


var max_health := 100
var current_health := 100

var last_direction = "down"
var is_moving = false
var moviment_position = Vector2.ZERO
var target_position = Vector2.ZERO
var target_pos: Vector2
var target_id: int
var atk_timer: Timer
var has_target: bool

func _ready():
	spell.visible = false
	target.visible = false
	moviment_position = global_position
	agent.target_position = global_position
	update_health_bar()
	
func _physics_process(delta):
	if is_moving:
		var direction = (moviment_position - global_position).normalized()
		var distance = SPEED * delta
		var to_target = moviment_position - global_position

		if to_target.length() <= distance:
			global_position = moviment_position
			is_moving = false

			if not (
				Input.is_action_pressed("ui_right") or
				Input.is_action_pressed("ui_left") or
				Input.is_action_pressed("ui_up") or
				Input.is_action_pressed("ui_down")
			):
				play_idle()
		else:
			var collision = move_and_collide(direction * distance)
			if collision:
				is_moving = false
				play_idle()  # interrompe o movimento se colidir
	else:
		var input_vector = Vector2.ZERO
		if Input.is_action_pressed("ui_right"):
			input_vector.x += 1
		elif Input.is_action_pressed("ui_left"):
			input_vector.x -= 1
		elif Input.is_action_pressed("ui_down"):
			input_vector.y += 1
		elif Input.is_action_pressed("ui_up"):
			input_vector.y -= 1

		if input_vector != Vector2.ZERO:
			var test_target = global_position + input_vector * tile_size

			# Testa se haverá colisão antes de definir como target
			var collision = move_and_collide((test_target - global_position).normalized() * 1)
			if not collision:
				is_moving = true
				moviment_position = test_target
				play_walk(input_vector)

func play_walk(dir: Vector2):
	if abs(dir.x) > abs(dir.y):
		if dir.x > 0:
			anim.play("walk_right")
			last_direction = "right"
		else:
			anim.play("walk_left")
			last_direction = "left"
	else:
		if dir.y > 0:
			anim.play("walk_down")
			last_direction = "down"
		else:
			anim.play("walk_up")
			last_direction = "up"

func play_idle():
	anim.play("idle_" + last_direction)

func move_to_tile(pos: Vector2):
	moviment_position = pos
	is_moving = true

func on_atk(dummy_position: Vector2, dummy_id: int): 
	if(has_target):
		target_position = dummy_position
		target_id = dummy_id
		
		atk_timer = Timer.new()
		atk_timer.wait_time = 2.0
		atk_timer.one_shot = false
		atk_timer.connect("timeout", Callable(self, "shoot_projectile"))
		add_child(atk_timer)
		atk_timer.start()
	else:
		clear_target()
	
func clear_target():
	if(atk_timer):
		atk_timer.stop()
		atk_timer.queue_free()
		atk_timer = null
	

func shoot_projectile():	
	var is_out = is_out_of_range()
	var is_way = is_shootable()
	
	if(is_out || is_way):
		return
		
	var atk_min = info.atk_min
	var atk_max = info.atk_max
	var atk = randi_range(atk_min, atk_max)
	
	var new_spell = SpellScene.instantiate()
	new_spell.target_id = target_id
	new_spell.visible = true
	new_spell.damage = atk
	new_spell.global_position = global_position
	new_spell.set_as_top_level(true)
	
	var direction = (target_position - global_position).normalized()
	new_spell.set("direction", direction)
	get_parent().add_child(new_spell) 

func is_shootable():
	var ray = RayCast2D.new()
	add_child(ray)
	ray.global_position = global_position
	ray.target_position = target_position - global_position
	ray.enabled = true
	ray.force_raycast_update()

	if ray.is_colliding():
		var collider = ray.get_collider()
		ray.queue_free()
		
		return collider.name == "TileMap" || collider.name == "StaticBody2D"
	
	ray.queue_free()
	return false
	
func is_out_of_range():
	var distance_in_pixels = global_position.distance_to(target_position)
	var distance_in_tiles = int(distance_in_pixels / 32) - 1
	return distance_in_tiles > info.range
	
func update_health_bar():
	var percent: float = float(current_health) / float(max_health)
	var full_width: float = health_bar_backeground.size.x  # Use o nome real do nó de fundo
	health_bar_foreground.size.x = full_width * percent
