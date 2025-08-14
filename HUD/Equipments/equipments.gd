extends Panel

var items = []

@export var EquipmentItem: PackedScene
@onready var container: GridContainer = $MarginContainer/GridContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_prepare_equipments()


func on_prepare_equipments():
	for item in items:
		var inventory_item = EquipmentItem.instantiate()
		inventory_item.texture = item.texture
		
		container.add_child(inventory_item)
