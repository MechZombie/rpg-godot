extends Area2D

@onready var panel: Panel = $Panel
@onready var button: Button = $Button
@onready var texture_button: TextureButton = $TextureButton
@onready var container: GridContainer = $Panel/MarginContainer/GridContainer
@onready var take_all_area: Area2D = $Panel/TakeAllArea

@export var InventoryItem: PackedScene
@onready var player_inventory: InventoryData = preload("res://Resources/player_inventory.tres")


var player

var items: Array[Item] = []

func _ready() -> void:
	panel.visible = false
	input_event.connect(_on_input_event)
	take_all_area.input_event.connect(on_take_all)
	
	on_create_loot()
	await get_tree().create_timer(50).timeout
	queue_free()
	
	


func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		on_handle()

func on_handle():
	panel.visible = not panel.visible
	
func on_take_all(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		for item in items:
			player_inventory.on_add(item)
			
		queue_free()

func on_create_loot():
	for item in items:
		var inventory_item = InventoryItem.instantiate()
		inventory_item.data = item
		container.add_child(inventory_item)

	
