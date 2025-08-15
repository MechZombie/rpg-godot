extends Panel

var items = []
@onready var container: GridContainer = $MarginContainer/GridContainer
@export var ActionBarItem: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for item in items:
		var action_item = ActionBarItem.instantiate()
		action_item.texture = item.texture
		
		if item.cb:
			action_item.cb = item.cb

		
		container.add_child(action_item)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
