extends Resource

class_name PlayerHud

@export var spells: Array[Passive]
@export var passives: Array[Passive]

signal updated(items: Array[Passive]) 

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
