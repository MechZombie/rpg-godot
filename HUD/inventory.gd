extends Panel

@export var InventoryItem: PackedScene
@onready var container: GridContainer = $MarginContainer/GridContainer

var items = []




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_prepare_inventory()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_prepare_inventory():
	items = [
		{
			"name": "Poção vazia",
			"locked_time": 5.0,
			"texture": preload("res://Sprites/empty_vial.png"),
			"count": 1,
			"cb": null
		},
		{
			"name": "Gema verde",
			"locked_time": 5.0,
			"texture": preload("res://Sprites/green_gem.png"),
			"count": 2,
			"cb": null
		},
		{
			"name": "Poção de vida",
			"locked_time": 5.0,
			"texture": preload("res://Sprites/bag.png"),
			"count": null,
			"cb": null
		},
	]
	
	for item in items:
		var inventory_item = InventoryItem.instantiate()
		inventory_item.texture = item.texture
		
		if(item.count):
			inventory_item.label_value = item.count
		
		container.add_child(inventory_item)
		
	for item in 15 - items.size():
		var inventory_item = InventoryItem.instantiate()
		container.add_child(inventory_item)
		
