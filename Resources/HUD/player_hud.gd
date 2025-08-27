extends Resource

class_name PlayerHud

@export var spells: Array[Passive]
@export var passives: Array[Passive]
@export var current_mana: int
@export var max_mana: int

@export var max_life: int
@export var current_life: int
@export var level: int
@export var total_exp: int

@export var melee_level: int
@export var distance_level: int
@export var magic_level: int
@export var outfit: SpriteFrames
@export var available_outfits: Array[SpriteFrames]

signal updated(items: Array[Passive]) 
signal update_stats
signal update_outfit

func on_add(item: Passive):
	var passiveExists = passives.filter(func (el): return el.id == item.id)
	if item.type == "Passive" && passiveExists.size() == 0:
		if passives.size() == 3:
			passives.pop_back()
			
		passives.insert(0, item)
		updated.emit()
		return
		
	var activeExists = spells.filter(func (el): return el.id == item.id)
	if item.type == "Active" && activeExists.size() == 0:
		if spells.size() == 3:
			spells.pop_back() 

		spells.insert(0, item)
		updated.emit()

func on_set_outfit(data: SpriteFrames):
	print("set new outfit")
	outfit = data
	update_outfit.emit()
