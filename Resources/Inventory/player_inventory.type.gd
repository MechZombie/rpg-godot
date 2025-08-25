extends Resource

class_name InventoryData

@export var slots: Array[Item] = []

@export var helmet: Item
@export var left_ear: Item
@export var right_ear: Item
@export var gloves: Item
@export var armor: Item
@export var weapon: Item
@export var off_hand: Item
@export var shoes: Item
@export var legs: Item


signal updated(item: Item) 

func on_add(item: Item):
	var occuped_slots = slots.filter(func (el): return  el).size()
	if(occuped_slots >= 18):
		print("Inventory is full")
		return
	
	var itemExists = slots.filter(func (el):
		return el != null and el.id == item.id
	)
	
	if itemExists.size() > 0 and itemExists[0].is_stackable:
		itemExists[0].count += item.count
		updated.emit()
		return
		
	
	for i in range(slots.size()):
		var slot = slots[i]
		if slot == null or slot.id == null:
			slots[i] = item
			updated.emit()
			return
			
