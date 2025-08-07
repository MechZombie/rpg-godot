extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input_event(viewport, event, shape_idx):
	pass
	#var tilemap = get_parent().get_node("TileMap")
	#var player = get_parent().get_node("Player")
#
	#if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		#var world_pos = tilemap.get_global_mouse_position()
		#var clicked_cell = tilemap.local_to_map(world_pos)
#
		## Usa tile_size corretamente
		#var tile_size = Vector2(tilemap.tile_set.tile_size)
		#var cell_local = tilemap.map_to_local(clicked_cell)
		#var cell_center = cell_local + tile_size / 2.0
		#var target_position = tilemap.to_global(cell_center)
#
		#print("Centro do tile clicado (global):", target_position)
#
		#player.set_target_position(target_position)

	
