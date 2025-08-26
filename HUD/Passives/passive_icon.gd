extends NinePatchRect

@onready var button: Button = $MarginContainer/Button
@onready var title: Label = $Panel/MarginContainer/GridContainer/Title
@onready var texture_slot: TextureRect = $MarginContainer/Button/TextureRect
@onready var description: Label = $Panel/MarginContainer/GridContainer/Description
@onready var details: PanelContainer = $Panel
@onready var background: ColorRect = $Background
@onready var grid_container: GridContainer = $Panel/MarginContainer/GridContainer
@onready var cdr: Label = $Panel/MarginContainer/GridContainer/Cdr

var player_hud = preload("res://Resources/HUD/player_hud.tres")

var data: Passive

func _ready():
	button.pressed.connect(on_click)
	if not data:
		background.visible = false
		return
		
	texture_slot.texture = data.texture
	title.text = data.name
	description.text = data.description
	
	if data.coldown:
		cdr.text = "Tempo de recarga %s" % data.coldown
		
	on_prepare_button()
	
	
func on_prepare_button():
	var button = Button.new()
	button.text = "Equipar"
	
	var custom_font = FontFile.new()
	custom_font.font_data = load("res://Fonts/alagard.ttf")

	button.add_theme_font_override("font", custom_font)
	button.pressed.connect(on_handle_spell)
	grid_container.add_child(button)
	

func on_handle_spell():
	player_hud.on_add(data)
	on_click()
	
func on_click():
	if not data:
		return
		
	details.visible = not details.visible
	
