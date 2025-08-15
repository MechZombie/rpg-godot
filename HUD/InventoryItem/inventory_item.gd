extends Panel

@onready var texture_button: TextureButton = $TextureButton
@onready var label: Label = $Label
@onready var info: Panel = $Info
@onready var delete_button: TextureButton = $Info/DeleteButton
@onready var drop_item: TextureButton = $Info/DropItem




var texture
var label_value
var item

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible = false
	info.visible = false
	
	#texture_button.connect("pressed",Callable(self, "on_handle_info"))
	delete_button.pressed.connect(on_delete)
	#drop_item.pressed.connect(on_drop)

	
	if texture:
		texture_button.texture_normal = texture
		
	if(label_value):
		label.text = str(label_value)
		label.visible = true

#func on_drop():
	#var player = find_parent("Player")
	#var cav = find_parent("Cave")
	#player.inventory_items = player.inventory_items.filter(func (el):
		#return el.id != item.id
	#)
	#
	#var loot = DropBag.instantiate()
	#loot.position = player.global_position
	#loot.items.append(item)
	#loot.player = player
	#add_child(loot)

	
	
func on_delete():
	var player = find_parent("Player")
	player.inventory_items = player.inventory_items.filter(func (el):
		return el.id != item.id
	)
	queue_free()


func on_handle_info():
	info.visible = not info.visible
