extends Panel

var items = []
@onready var container: GridContainer = $GridContainer
@export var ActionBarItem: PackedScene

@onready var player_hud = preload("res://Resources/HUD/player_hud.tres")


func _ready() -> void:
	player_hud.updated.connect(on_mount_content)

func on_mount_content():
	for child in container.get_children():
		child.queue_free()
		
	for item in player_hud.spells:
		if not item:
			return
			
		var action_item = ActionBarItem.instantiate()
		action_item.spell = item
		container.add_child(action_item)
		
		#if item.cb:
			#action_item.cb = item.cb
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
