extends NinePatchRect

@onready var texture_button: TextureButton = $MarginContainer/TextureButton
@onready var count_label: Label = $MarginContainer/TextureButton/Count
@onready var margin_container: MarginContainer = $Details/MarginContainer
@onready var details: PanelContainer = $Panel
@onready var grid_container: GridContainer = $Panel/MarginContainer/GridContainer
@onready var item_name: Label = $Panel/MarginContainer/GridContainer/Label
@onready var description: Label = $Panel/MarginContainer/GridContainer/Description
@onready var atk: Label = $Panel/MarginContainer/GridContainer/Atk



var data: Item

func _ready():
	if not data:
		return
	
	texture_button.pressed.connect(on_click)
		
	item_name.text = str(data.name)
	description.text = str(data.description)
	
	if data.texture:
		texture_button.texture_normal = data.texture
		
	if data.count:
		count_label.text = str(data.count)
		
		
	if not data.is_equipable:
		return
		
	if data.atk_min:
		atk.text = "Atk %s ~ %s " % [data.atk_min, data.atk_max]
		atk.visible = true
		
	if data.def_min:
		var range = atk.duplicate()
		range.text = "Def %s ~ %s " % [data.def_min, data.def_max]
		range.visible = true
		grid_container.add_child(range)
		
	if data.level:
		var level = atk.duplicate()
		level.text = "Nível %s" % data.level
		level.visible = true
		grid_container.add_child(level)
		
	if data.range:
		var range = atk.duplicate()
		range.text = "Alcance %s" % [data.range]
		range.visible = true
		grid_container.add_child(range)
		
	if data.type == "Melee":
		var type = atk.duplicate()
		type.text = "Corpo a corpo"
		type.visible = true
		grid_container.add_child(type)
		
	if data.vocation:
		var vocation = atk.duplicate()
		vocation.text = "Usado por [ %s ]" % [data.vocation]
		vocation.visible = true
		grid_container.add_child(vocation)
		
	if data.is_equipable:
		on_prepare_button()
		
	
		
		
func on_prepare_button():
	var button = Button.new()
	button.text = "Equipar"
	
	var custom_font = FontFile.new()
	custom_font.font_data = load("res://Fonts/alagard.ttf")

	button.add_theme_font_override("font", custom_font)
	grid_container.add_child(button)

func on_click():
	details.visible = not details.visible
	
