extends NinePatchRect

@onready var stats_button: Button = $NinePatchRect/MarginContainer/Title/GridContainer/Button2
@onready var stats_panel: Panel = $StatsPanel
@onready var equipments: MarginContainer = $NinePatchRect/Equipments
@onready var inventory: VBoxContainer = $NinePatchRect/Inventory
@onready var skills_button: Button = $NinePatchRect/MarginContainer/Title/GridContainer/Skills
@onready var inventory_button: Button = $NinePatchRect/MarginContainer/Title/GridContainer/Inventory
@onready var skills_container: MarginContainer = $NinePatchRect/Skills
@onready var stats_continer: MarginContainer = $NinePatchRect/Stats
@onready var inventory_grid: GridContainer = $NinePatchRect/Inventory/MarginContainer2/GridContainer

@onready var outfit_button: Button = $NinePatchRect/MarginContainer/Title/GridContainer/Outfit
@onready var outfit_container: GridContainer = $NinePatchRect/OutfitMargin/GridContainer
@onready var outfit_margin: MarginContainer = $NinePatchRect/OutfitMargin

@export var InventoryItem: PackedScene
@export var Passive: PackedScene
@export var OutfitSelector: PackedScene

@onready var ear_left_slot: NinePatchRect = $NinePatchRect/Equipments/GridContainer/EarLeft
@onready var ear_right_slot: NinePatchRect = $NinePatchRect/Equipments/GridContainer/EarRight
@onready var helmet_slot: NinePatchRect = $NinePatchRect/Equipments/GridContainer/Helmet
@onready var gloves_slot: NinePatchRect = $NinePatchRect/Equipments/GridContainer/Gloves
@onready var armor_slot: NinePatchRect = $NinePatchRect/Equipments/GridContainer/Armor
@onready var off_hand_slot: NinePatchRect = $NinePatchRect/Equipments/GridContainer/OffHand
@onready var weapon_slot: NinePatchRect = $NinePatchRect/Equipments/GridContainer/Weapon
@onready var legs_slot: NinePatchRect = $NinePatchRect/Equipments/GridContainer/Legs
@onready var shoes_slot: NinePatchRect = $NinePatchRect/Equipments/GridContainer/Shoes
@onready var passives_grid: GridContainer = $NinePatchRect/Skills/VBoxContainer/PassivesGrid
@onready var actives_grid: GridContainer = $NinePatchRect/Skills/VBoxContainer/ActiveGrid

@onready var inventory_data = preload("res://Resources/Inventory/player_inventory.tres")
@onready var passives_data = preload("res://Spells/Passives/player_passives.tres")
@onready var player_hud = preload("res://Resources/HUD/player_hud.tres")

@onready var actives_count: Label = $NinePatchRect/Skills/VBoxContainer/ActivesCount
@onready var passives_count: Label = $NinePatchRect/Skills/VBoxContainer/PassivesCount
@onready var life_value: Label = $NinePatchRect/Stats/Container/LifeContainer/Value
@onready var mana_value: Label = $NinePatchRect/Stats/Container/ManaContainer/Value
@onready var level_value: Label = $NinePatchRect/Stats/Container/LevelContainer/Value
@onready var melee_value: Label = $NinePatchRect/Stats/Container/MeeleeContainer/Value
@onready var distance_value: Label = $NinePatchRect/Stats/Container/DistanceContainer/Value
@onready var magic_value: Label = $NinePatchRect/Stats/Container/MagicContainer/Value


func _ready():
	stats_button.pressed.connect(on_handle_stats)
	stats_continer.visible = false
	
	skills_button.pressed.connect(on_handle_skills)
	inventory_button.pressed.connect(on_handle_inventory)
	outfit_button.pressed.connect(on_handle_outfits)
	
	skills_container.visible = false
	
	inventory_data.connect("updated", Callable(self, "on_prepare_slots"))
	passives_data.connect("update", Callable(self, "on_prepare_passives"))
	player_hud.connect("update_stats", Callable(self, "on_prepare_stats"))
	
	
	on_prepare_slots()
	on_prepare_equipments()
	on_prepare_passives()
	on_prepare_stats()
	on_prepare_outfits()
	
	
func on_prepare_outfits():
	for data in player_hud.available_outfits:
		var outfit = OutfitSelector.instantiate()
		outfit.animation = data
		outfit_container.add_child(outfit)
	
func on_prepare_stats():
	life_value.text = str(player_hud.max_life)
	mana_value.text = str(player_hud.max_mana)
	level_value.text = str(player_hud.level)
	melee_value.text = str(player_hud.melee_level)
	distance_value.text = str(player_hud.distance_level)
	magic_value.text = str(player_hud.magic_level)
	
func on_prepare_passives():
	passives_count.text = str("Passivas (%s/%s)" % [passives_data.deactivated.size(), 3])
	for item in passives_data.deactivated:
		var passive = Passive.instantiate()
		passive.data = item
		passives_grid.add_child(passive)
		
	actives_count.text = str("Ativas (%s/%s)" % [passives_data.activated.size(), 3])
	
	for item in passives_data.activated:
		var active = Passive.instantiate()
		active.data = item
		actives_grid.add_child(active)
	
	
func on_prepare_equipments():
	var helmet = InventoryItem.instantiate()
	helmet.data = inventory_data.helmet
	helmet_slot.add_child(helmet)
	
	var left_ear = InventoryItem.instantiate()
	left_ear.data = inventory_data.left_ear
	ear_left_slot.add_child(left_ear)
	
	var right_ear = InventoryItem.instantiate()
	right_ear.data = inventory_data.right_ear
	ear_right_slot.add_child(right_ear)
	
	var gloves = InventoryItem.instantiate()
	gloves.data = inventory_data.gloves
	gloves_slot.add_child(gloves)
	
	var armor = InventoryItem.instantiate()
	armor.data = inventory_data.armor
	armor_slot.add_child(armor) 
	
	var weapon = InventoryItem.instantiate()
	weapon.data = inventory_data.weapon
	weapon_slot.add_child(weapon) 
	
	var off_hand = InventoryItem.instantiate()
	off_hand.data = inventory_data.off_hand
	off_hand_slot.add_child(off_hand) 
	
	var shoes = InventoryItem.instantiate()
	shoes.data = inventory_data.shoes
	shoes_slot.add_child(shoes) 
	
	var legs = InventoryItem.instantiate()
	legs.data = inventory_data.legs
	legs_slot.add_child(legs) 

func on_prepare_slots():
	for child in inventory_grid.get_children():
		child.queue_free()
		
	for res in inventory_data.slots:
		var item = InventoryItem.instantiate()
		item.data = res
		inventory_grid.add_child(item)
		


func on_handle_skills():
	skills_container.visible = true
	
	equipments.visible = false
	inventory.visible = false
	stats_continer.visible = false
	outfit_margin.visible = false
	

func on_handle_inventory():
	equipments.visible = true
	inventory.visible = true
	
	stats_continer.visible = false
	skills_container.visible = false
	outfit_margin.visible = false
	

func on_handle_stats():
	stats_continer.visible = true
	
	equipments.visible = false
	inventory.visible = false
	skills_container.visible = false
	outfit_margin.visible = false
	

func on_handle_outfits():
	outfit_margin.visible = true
	
	stats_continer.visible = false
	equipments.visible = false
	inventory.visible = false
	skills_container.visible = false
	
