extends TileMap

@export var tile_size := 32
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input_event(viewport, event, shape_idx):
	print('clicado')
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		var clicked_cell = local_to_map(to_local(mouse_pos))
		var cell_center = map_to_local(clicked_cell) + Vector2(tile_size / 2, tile_size / 2)

		var player = get_node("/root/Main/Player") # ajuste conforme seu caminho real
		player.set_target_position(cell_center)
