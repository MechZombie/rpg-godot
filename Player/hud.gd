extends CanvasLayer

@onready var health_bar_foreground: ColorRect = $MarginContainer/PlayerContainer/LifeBar/Foreground
@onready var health_bar_backeground: ColorRect = $MarginContainer/PlayerContainer/LifeBar/Background

@onready var enemy_health_bar_foreground: ColorRect = $MarginContainer/EnemyContainer/LifeBar/Foreground
@onready var enemy_health_bar_backeground: ColorRect = $MarginContainer/EnemyContainer/LifeBar/Background
@onready var creature_name: Label = $MarginContainer/EnemyContainer/LifeBar/Name


@onready var skills_bar: HBoxContainer = $MarginContainer/SkillsBar
@export var slot_scene: PackedScene

var is_slot1_cdr: bool

var action_bar_items = []
var player

func on_prepare_action_bar():
	action_bar_items = [
		{
			"name": "Poção de vida",
			"locked_time": 5.0,
			"texture": preload("res://Sprites/hud_spell_heal_1.png"),
			"count": null,
			"cb": player.on_heal
		},
		{
			"name": "Bola de fogo",
			"locked_time": 5.0,
			"texture": preload("res://Sprites/hud_spell_fire_3.png"),
			"count": null,
			"cb": func(): player.shoot_spell("great_fire_ball")
		},
		{
			"name": "Poção de vida",
			"locked_time": 5.0,
			"texture": preload("res://Sprites/hud_spell_fire_4.png"),
			"count": null,
			"cb": null
		},
	]
	
	for item in action_bar_items:
		var action_item = slot_scene.instantiate()
		action_item.texture = item.texture
		if(item.count):
			action_item.label_value = item.count
			
		if(item.cb):
			action_item.cb = item.cb
		skills_bar.add_child(action_item)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()
	player.connect("health_changed", Callable(self, "set_health"))
	
	call_deferred("on_prepare_action_bar")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_health(value):
	var full_width: float = health_bar_backeground.size.x  
	health_bar_foreground.size.x = full_width * value

func set_enemy_health(value):
	var full_width: float = enemy_health_bar_backeground.size.x  
	enemy_health_bar_foreground.size.x = full_width * value

func set_enemy_name(name):
	creature_name.text = name




	
