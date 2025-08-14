extends CharacterBody2D
const FloatingText = preload("res://Objects/Hit/hit_damage.tscn")

var speed = 70
@export var BasicAtkScene: PackedScene
@export var GreatFireBallScene: PackedScene
@export var UltimateExplosionScene: PackedScene


@export var tile_size := Vector2(32,32)
@onready var spell = $Spell
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var anim = $AnimatedSprite2D
@onready var target = $Target

@onready var ray_down = $RayCastDown
@onready var ray_up = $RayCastUp
@onready var ray_left = $RayCastLeft
@onready var ray_right = $RayCastRight
@onready var enemy_life_bar: Control = $HUD/MarginContainer/EnemyContainer/LifeBar



var info := {
	"id": 1,
	"atk_min": 5,
	"atk_max": 10,
	"range": 3,
	"def": 3,
	"magic_power": 5
}


var max_health := 100
var current_health := 100
signal health_changed(new_health)

var last_direction = "down"
var is_moving = false
var moviment_position = Vector2.ZERO
var target_position = Vector2.ZERO
var target_pos: Vector2
var target_id: int
var atk_timer: Timer
var has_target: bool

func _ready():
	target.visible = false
	moviment_position = global_position
	agent.target_position = global_position
	
	agent.avoidance_enabled = true
	agent.radius = 15.9
	agent.max_speed = speed
	
	enemy_life_bar.visible = false
	update_health_bar()
	

	
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1

	input_vector = input_vector.normalized()

	if input_vector != Vector2.ZERO:
		# movimentação direta sem colisão grudenta
		velocity = input_vector * speed
		move_and_slide()
		play_walk(input_vector)
	else:
		velocity = Vector2.ZERO
		play_idle()
	
	
func on_receive_damage(atk: float, color: Color, left_position: float):
	var damage = atk - info.def
	current_health -= damage
	update_health_bar()
	on_show_hit(damage, color, left_position)
	
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

func on_heal():
	var heal = info.magic_power + ( max_health / 10)
	var totalLife = current_health + heal
	
	if(totalLife  >= max_health):
		current_health = max_health
	else:
		current_health = totalLife
		
	update_health_bar()
	
func on_atk(): 
	if(has_target):
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
		enemy_life_bar.visible = false
	
func on_show_hit(damage, color: Color, left_position: float):
	var dmg_label = FloatingText.instantiate()
	dmg_label.label_settings = dmg_label.label_settings.duplicate() # cria cópia
	dmg_label.label_settings.font_color = color
	
	if damage > 0:
		dmg_label.text = "-" + str(damage)
	else:
		dmg_label.text = "Miss"
		
	dmg_label.global_position = global_position + Vector2(left_position, -35)  
	current_health -= damage
	get_tree().current_scene.add_child(dmg_label)
	
func shoot_projectile():	
	var cav = get_parent()
	var creatures = cav.creature_instances
	
	for creature in creatures:
		if(is_instance_valid(creature) and creature.info.id == target_id):
			target_position = creature.global_position
			
	var is_out = is_out_of_range()
	var is_way = is_shootable()
	
	if(is_out || is_way):
		return
		
	on_basic_atk()

func shoot_spell(type: String):
	var cav = get_parent()
	var creatures = cav.creature_instances
	
	for creature in creatures:
		if(is_instance_valid(creature) and creature.info.id == target_id):
			target_position = creature.global_position
			
	var is_out = is_out_of_range()
	var is_way = is_shootable()
	
		
	if(type == "great_fire_ball" and not is_out and not is_way):
		on_great_fire_ball()
	
	if(type == "on_ultimate_explosion"):
		on_ultimate_explosion()


func on_great_fire_ball():
	var damage = info.magic_power + randi_range(info.atk_min, info.atk_max)
	var gfb = GreatFireBallScene.instantiate()
	
	gfb.set_as_top_level(true)
	gfb.target_id = target_id
	gfb.damage = damage
	gfb.global_position = global_position
	gfb.target_position = target_position
	
	var direction = (target_position - global_position).normalized()
	gfb.set("direction", direction)
	get_parent().add_child(gfb) 
	
func on_ultimate_explosion():
	var damage = info.magic_power + randi_range(info.atk_min, info.atk_max)
	var ultimate = UltimateExplosionScene.instantiate()
	
	ultimate.set_as_top_level(true)
	ultimate.target_id = target_id
	ultimate.damage = damage
	ultimate.global_position = global_position
	
	var direction = (target_position - global_position).normalized()
	get_parent().add_child(ultimate) 


func on_basic_atk():
	var atk_min = info.atk_min
	var atk_max = info.atk_max
	var atk = randi_range(atk_min, atk_max)
	
	var new_spell = BasicAtkScene.instantiate()
	new_spell.set_as_top_level(true)
	new_spell.target_id = target_id
	new_spell.visible = true
	new_spell.damage = atk
	new_spell.global_position = global_position
	
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
	if target_position == Vector2.ZERO:
		return true
		
	var distance_in_pixels = global_position.distance_to(target_position)
	var distance_in_tiles = int(distance_in_pixels / 32) - 1
	return distance_in_tiles > info.range 
	
func update_health_bar():
	var percent: float = float(current_health) / float(max_health)
	emit_signal("health_changed", percent)
	
func set_target_position(pos: Vector2):
	moviment_position = pos
	is_moving = true
	print("Target definido via clique:", pos)
