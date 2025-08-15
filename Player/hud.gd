extends CanvasLayer

@onready var health_bar_foreground: ColorRect = $MarginContainer/PlayerContainer/LifeBar/Foreground
@onready var health_bar_backeground: ColorRect = $MarginContainer/PlayerContainer/LifeBar/Background


@onready var enemy_life_bar: Control = $MarginContainer/EnemyContainer/LifeBar
@onready var enemy_health_bar_foreground: ColorRect = $MarginContainer/EnemyContainer/LifeBar/Foreground
@onready var enemy_health_bar_backeground: ColorRect = $MarginContainer/EnemyContainer/LifeBar/Background
@onready var creature_name: Label = $MarginContainer/EnemyContainer/LifeBar/Name

@onready var action_bar: Panel = $MarginContainer/SkillsBar/Control/ActionBar
@onready var control: Control = $MarginContainer/SkillsBar/Control
@onready var inventory_container: VBoxContainer = $MarginContainer/Inventory
@onready var inventory_handler: TextureButton = $MarginContainer/OptionsContainer/Panel/InventoryHandler
@onready var options_container: VBoxContainer = $MarginContainer/OptionsContainer
@onready var skills_container: VBoxContainer = $MarginContainer/SkillsContainer


@export var ActionBarScene: PackedScene
@export var InventoryScene: PackedScene
@export var EquipmentsScene: PackedScene


var action_bar_items = []
var inventory_items = []
	
var equipment_items = [
		{
			"name": "Brincos 1",
			"texture": preload("res://Sprites/feather_1.png"),
			"cb": null
		},
		{
			"name": "Capacete",
			"texture": preload("res://Sprites/helmet_1.png"),
			"cb": null
		},
		{
			"name": "Brincos 2",
			"texture": preload("res://Sprites/feather_2.png"),
			"cb": null
		},
		{
			"name": "Arma",
			"texture": preload("res://Sprites/weapon_1.png"),
			"cb": null
		},
		{
			"name": "Armadura",
			"texture": preload("res://Sprites/armor_1.png"),
			"cb": null
		},
		{
			"name": "Escudo",
			"texture": preload("res://Sprites/book_1.png"),
			"cb": null
		},
		{
			"name": "Botas",
			"texture": preload("res://Sprites/shoes_1.png"),
			"cb": null
		},
		{
			"name": "Calças",
			"texture": preload("res://Sprites/legs_1.png"),
			"cb": null
		},
		{
			"name": "Luvas",
			"texture": preload("res://Sprites/gloves_1.png"),
			"cb": null
		},
	]

var player
var inventory
var equipments



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()
	player.connect("health_changed", Callable(self, "set_health"))
	inventory_handler.pressed.connect(on_handle_inventory)
	
	on_prepare_equipments()
	on_prepare_inventory()
	on_prepare_action_bar()
	

func on_handle_inventory():
	inventory.visible = not inventory.visible
	equipments.visible = not equipments.visible

func on_prepare_inventory():
	if inventory and is_instance_valid(inventory):
		inventory.queue_free()
		
	inventory = InventoryScene.instantiate()
	inventory.items = inventory_items
	inventory_container.add_child(inventory)
	
func on_prepare_equipments():
	equipments = EquipmentsScene.instantiate()
	equipments.items = equipment_items
	inventory_container.add_child(equipments)
	
func on_prepare_action_bar():
	action_bar_items = [
		{
			"name": "Heal Speal",
			"locked_time": 5.0,
			"texture": preload("res://Sprites/hud_spell_heal_1.png"),
			"count": null,
			"cb": player.on_heal
		},
		{
			"name": "Great Fire Ball",
			"locked_time": 5.0,
			"texture": preload("res://Sprites/hud_spell_fire_3.png"),
			"count": null,
			"cb": func(): player.shoot_spell("great_fire_ball")
		},
		{
			"name": "Ultimate Explosion",
			"locked_time": 5.0,
			"texture": preload("res://Sprites/hud_spell_fire_4.png"),
			"count": null,
			"cb": func(): player.shoot_spell("on_ultimate_explosion")
		},
		{
			"name": "Espaço vazio",
			"locked_time": 5.0,
			"texture": null,
			"count": null,
			"cb": null
		}
	]
	
	var action_bar = ActionBarScene.instantiate()
	action_bar.items = action_bar_items
	skills_container.add_child(action_bar)
	
func set_health(value):
	var full_width: float = health_bar_backeground.size.x  
	health_bar_foreground.size.x = full_width * value

func set_enemy_health(value):
	var full_width: float = enemy_health_bar_backeground.size.x  
	enemy_health_bar_foreground.size.x = full_width * value

func set_enemy_name(name):
	creature_name.text = name




	
