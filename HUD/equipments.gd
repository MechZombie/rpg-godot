extends Panel

var equipments = []

@export var EquipmentItem: PackedScene
@onready var container: GridContainer = $MarginContainer/GridContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	on_prepare_inventory()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_prepare_inventory():
	equipments = [
		{
			"name": "Capacete",
			"texture": preload("res://Sprites/helmet_1.png"),
			"cb": null
		},
		{
			"name": "Armadura",
			"texture": preload("res://Sprites/armor_1.png"),
			"cb": null
		},
		{
			"name": "Botas",
			"texture": preload("res://Sprites/shoes_1.png"),
			"cb": null
		},
		{
			"name": "Arma",
			"texture": preload("res://Sprites/weapon_1.png"),
			"cb": null
		},
		{
			"name": "Escudo",
			"texture": preload("res://Sprites/book_1.png"),
			"cb": null
		},
	]
	
	for item in equipments:
		var inventory_item = EquipmentItem.instantiate()
		inventory_item.texture = item.texture

		
		container.add_child(inventory_item)
