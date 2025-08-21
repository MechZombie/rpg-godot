extends NinePatchRect

@onready var stats_button: Button = $NinePatchRect/MarginContainer/Title/GridContainer/Button2
@onready var stats_panel: Panel = $StatsPanel
@onready var equipments: MarginContainer = $NinePatchRect/Equipments
@onready var inventory: VBoxContainer = $NinePatchRect/Inventory
@onready var skills_button: Button = $NinePatchRect/MarginContainer/Title/GridContainer/Skills
@onready var inventory_button: Button = $NinePatchRect/MarginContainer/Title/GridContainer/Inventory
@onready var skills_container: MarginContainer = $NinePatchRect/Skills


func _ready():
	stats_button.pressed.connect(on_handle_stats)
	stats_panel.visible = false
	
	skills_button.pressed.connect(on_handle_skills)
	inventory_button.pressed.connect(on_handle_inventory)
	
	skills_container.visible = false
	

func on_handle_stats():
	stats_panel.visible = not stats_panel.visible

func on_handle_skills():
	equipments.visible = false
	inventory.visible = false
	
	skills_container.visible = true

func on_handle_inventory():
	equipments.visible = true
	inventory.visible = true
	
	skills_container.visible = false
