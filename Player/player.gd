extends CharacterBody2D
const FloatingText = preload("res://Objects/Hit/hit_damage.tscn")

var speed = 70
@export var BasicAtkScene: PackedScene
@export var GreatFireBallScene: PackedScene
@export var UltimateExplosionScene: PackedScene
@export var LightHealScene: PackedScene
@export var HUDScene: PackedScene
@export var DeadScene: PackedScene
@export var LevelUPScene: PackedScene


@export var tile_size := Vector2(32,32)
@onready var spell = $Spell
@onready var agent: NavigationAgent2D = $NavigationAgent2D
@onready var anim = $AnimatedSprite2D
@onready var target = $Target

@onready var ray_down = $RayCastDown
@onready var ray_up = $RayCastUp
@onready var ray_left = $RayCastLeft
@onready var ray_right = $RayCastRight
@onready var enemy_life_bar: Control = $MarginContainer/EnemyContainer/LifeBar

@onready var regen_timer: Timer = $RegenTimer

var HUD: CanvasLayer
var levels = [
	{
		"id": 1,
		"min_exp": 0,
		"max_exp": 99
	},
	{
		"id": 2,
		"min_exp": 100,
		"max_exp": 199
	},
	{
		"id": 3,
		"min_exp": 200,
		"max_exp": 299
	},
	{
		"id": 4,
		"min_exp": 300,
		"max_exp": 399
	},
]

var info := {
	"id": 1,
	"atk_min": 10,
	"atk_max": 20,
	"range": 3,
	"def": 3,
	"magic_power": 10,
	"life_regen": 2,
	"mana_regen": 1,
	"level": 1,
	"exp": 0,
	"acc_level_exp": 0
}



var max_health := 100
var current_health := 100
signal health_changed(new_health)

var max_mana := 100
var current_mana := 100
signal mana_changed(new_mana)

signal level_up(value: int, exp: int, max_level_exp: int, acc_level_exp: int)

var last_direction = "down"
var is_moving = false
var moviment_position = Vector2.ZERO
var target_position = Vector2.ZERO
var target_pos: Vector2
var target_id: int
var atk_timer: Timer
var has_target: bool

var is_alive: bool = true

var dead_scene

var inventory_items = [
		{
			"id": 1,
			"name": "Fire Sword",
			"locked_time": 0.0,
			"texture": preload("res://Sprites/fire_sword.png"),
			"count": null,
			"cb": null
		},
	]

func _ready():
	target.visible = false
	moviment_position = global_position
	agent.target_position = global_position
	
	agent.avoidance_enabled = true
	agent.radius = 15.9
	agent.max_speed = speed
	
	on_prepare_hud()
	update_health_bar()
	update_hud_level()
	
	regen_timer.timeout.connect(on_regenerate)
	
	
func on_gain_exp(value: int):
	var level_data = levels.filter(func(el): return el["id"] == info["level"])
	if level_data.is_empty():
		print("Level not found")
		return
		
		
	var max_level_exp = level_data[0].max_exp
	var total_exp = (info.exp + value)
	info.exp = total_exp
	info.acc_level_exp += value
	
	if(total_exp > max_level_exp):
		on_level_up()
		
	update_hud_level()
	
func on_level_up():
	var exp = info.exp
	var new_level = levels.filter(func (el): return exp >= el["min_exp"] and exp < el["max_exp"])
	if new_level.is_empty():
		print("Level max reached")
		return
	
	var levelLabel = LevelUPScene.instantiate()
	add_child(levelLabel)
	info.level = new_level[0].id
	info.acc_level_exp = 0
	
	
func on_regenerate():
	if(not is_alive):
		return
		
	var total_life_regen = (current_health + info.life_regen)
	if(total_life_regen >= max_health):
		current_health = max_health
	else:
		current_health = total_life_regen
		
	var total_mana_regen = (current_mana + info.mana_regen)
	if(total_mana_regen >= max_mana):
		current_mana = max_mana
	else:
		current_mana = total_mana_regen
		
	update_health_bar()
	update_mana_bar()
	
	
func on_dead():
	dead_scene = DeadScene.instantiate()
	dead_scene.cb = Callable(self, "on_rebirth")
	HUD.add_child(dead_scene)
	is_alive = false
	
	
func on_rebirth():
	global_position = Vector2(480, -200)
	is_alive = true
	dead_scene.queue_free()
	
	current_health = max_health
	update_health_bar()
	
	current_mana = max_mana
	update_mana_bar()
	
	anim.play("idle_down")
	


	
func on_prepare_hud():
	if HUD and is_instance_valid(HUD):
		HUD.queue_free()
		
	HUD = HUDScene.instantiate()
	HUD.inventory_items = inventory_items
	add_child(HUD)
	
	
func on_update_inventory(items: Array):
	if inventory_items.size() == 15:
		print("Inventory full")
		return
		
		
	for item in items:
		var found = false
		
		for i in range(inventory_items.size()):
			if inventory_items[i].id == item.id:
				inventory_items[i].count += item.count
				found = true
				break  # já encontrou, não precisa continuar
		
		# se terminou o loop sem encontrar, adiciona
		if not found:
			inventory_items.append(item)
			
	
	HUD.inventory_items = inventory_items
	HUD.on_prepare_inventory()
		
	
func _physics_process(delta):
	if not is_alive:
		return
		
	
	var input_vector = Vector2.ZERO
	
	input_vector = Vector2.ZERO
	input_vector = Input.get_vector("ui_left","ui_right","ui_up","ui_down")

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
	var mana_cost = 5
	var light = LightHealScene.instantiate()
	add_child(light) 
	
	current_mana -= mana_cost
	
	var rng_heal = randi_range(0, 10)
	var heal = info.magic_power + ( max_health / 10) + rng_heal
	var totalLife = current_health + heal
	
	on_show_heal(heal)
	on_show_mana_cost(mana_cost)
	update_mana_bar()
	
	
	if(totalLife  >= max_health):
		current_health = max_health
	else:
		current_health = totalLife
		
	update_health_bar()
	
func on_show_mana_cost(value):
	var dmg_label = FloatingText.instantiate()
	dmg_label.label_settings = dmg_label.label_settings.duplicate()
	dmg_label.label_settings.font_color = Color.BLUE
	
	dmg_label.text = "-" + str(value)
		
	dmg_label.global_position = global_position + Vector2(0, -25)  
	get_tree().current_scene.add_child(dmg_label)
	
	
func on_show_heal(damage):
	var dmg_label = FloatingText.instantiate()
	dmg_label.label_settings = dmg_label.label_settings.duplicate() # cria cópia
	dmg_label.label_settings.font_color = Color.GREEN
	
	dmg_label.text = "+" + str(damage)
		
	dmg_label.global_position = global_position + Vector2(0, -35)  
	get_tree().current_scene.add_child(dmg_label)
	
	
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
		HUD.enemy_life_bar.visible = false
	
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
	var mana_cost = 5
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
	
	current_mana -= mana_cost
	on_show_mana_cost(mana_cost)
	update_mana_bar()
	
func on_ultimate_explosion():
	var mana_cost = 20
	var damage = info.magic_power + randi_range(info.atk_min, info.atk_max)
	var ultimate = UltimateExplosionScene.instantiate()
	
	ultimate.set_as_top_level(true)
	ultimate.target_id = target_id
	ultimate.damage = damage
	ultimate.global_position = global_position
	
	var direction = (target_position - global_position).normalized()
	get_parent().add_child(ultimate) 
	
	current_mana -= mana_cost
	on_show_mana_cost(mana_cost)
	update_mana_bar()


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
	
	if current_health <= 0 and is_alive:
		on_dead()
		
func update_mana_bar():
	var percent: float = float(current_mana) / float(max_mana)
	emit_signal("mana_changed", percent)
	

func update_hud_level():
	var level_data = levels.filter(func(el): return el["id"] == info["level"])
	if level_data.is_empty():
		print("Level not found")
		return
		
	var max_level_exp = level_data[0].max_exp
	emit_signal("level_up", info["level"], info["exp"], max_level_exp, info.acc_level_exp)
	
func set_target_position(pos: Vector2):
	moviment_position = pos
	is_moving = true
	print("Target definido via clique:", pos)
