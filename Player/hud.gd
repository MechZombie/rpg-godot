extends CanvasLayer

@onready var health_bar_foreground: ColorRect = $MarginContainer/PlayerContainer/LifeBar/Foreground
@onready var health_bar_backeground: ColorRect = $MarginContainer/PlayerContainer/LifeBar/Background

@onready var enemy_health_bar_foreground: ColorRect = $MarginContainer/EnemyContainer/LifeBar/Foreground
@onready var enemy_health_bar_backeground: ColorRect = $MarginContainer/EnemyContainer/LifeBar/Background
@onready var creature_name: Label = $MarginContainer/EnemyContainer/LifeBar/Name
@onready var heal_button: TextureButton = $MarginContainer/SkillsBar/Slot1/MarginContainer/HBoxContainer/Heal
@onready var slot_1: Panel = $MarginContainer/SkillsBar/Slot1

var is_slot1_cdr: bool


var player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent()
	player.connect("health_changed", Callable(self, "set_health"))
	
	heal_button.connect("pressed",Callable(self, "_on_heal_button_pressed"))
	


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


func _on_heal_button_pressed():
	var cdr = slot_1.get_node("Cooldown")
	is_slot1_cdr = true
	cdr.visible = is_slot1_cdr
	player.on_heal()
	
	await get_tree().create_timer(5).timeout
	
	is_slot1_cdr = false
	cdr.visible = is_slot1_cdr

	
