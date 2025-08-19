extends Panel


@export var InventoryItem: PackedScene
@onready var container: GridContainer = $MarginContainer/GridContainer

var items = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_prepare_inventory()

func on_prepare_inventory():
	for item in items:
		var inventory_item = InventoryItem.instantiate()
		inventory_item.texture = item.texture
		inventory_item.item = item
		
		if(item.count):
			inventory_item.label_value = item.count
		
		container.add_child(inventory_item)
		
	for item in 9 - items.size():
		var inventory_item = InventoryItem.instantiate()
		container.add_child(inventory_item)
		
