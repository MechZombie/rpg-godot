extends CanvasLayer

@onready var health_bar_foreground: ColorRect = $MarginContainer/Container/LifeBar/Foreground
@onready var health_bar_backeground: ColorRect = $MarginContainer/Container/LifeBar/Background

@onready var enemy_health_bar_foreground: ColorRect = $MarginContainer/EnemyContainer/LifeBar/Foreground
@onready var enemy_health_bar_backeground: ColorRect = $MarginContainer/EnemyContainer/LifeBar/Background

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_parent()
	player.connect("health_changed", Callable(self, "set_health"))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_health(value):
	var full_width: float = health_bar_backeground.size.x  
	health_bar_foreground.size.x = full_width * value

func set_enemy_health(value):
	var full_width: float = enemy_health_bar_backeground.size.x  
	enemy_health_bar_foreground.size.x = full_width * value
