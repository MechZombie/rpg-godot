extends CharacterBody2D

var tile_map: TileMap
var astar_grid: AStarGrid2D
var tile_size: Vector2 = Vector2(32,32)
var speed: float = 80.0
var playerArea: Area2D
var is_moving: bool = false

var target_position: Vector2

var sprite: Sprite2D
var collision: CollisionShape2D


func _ready() -> void:
	var player = get_parent().get_node("Player")
	playerArea = player.get_node("Area2D")
	sprite = get_node("Sprite2D")
	collision = get_node("CollisionShape2D")
	
	astar_grid = AStarGrid2D.new()
	tile_map = get_parent().get_node("TileMap")
	
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = tile_size
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	var region_size = astar_grid.region.size
	var region_position = astar_grid.region.position
	
	for x in region_size.x:
		for y in region_size.y:
			var tile_position = Vector2i(
				x + region_position.x,
				y + region_position.y
			)
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			
			if(tile_data == null or not tile_data.get_custom_data("walkable")):
				astar_grid.set_point_solid(tile_position)
		



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_moving:
		return
	
	move()
		
		
	
func _physics_process(delta: float) -> void:
	if is_moving:
		var diff = target_position - global_position

		# Reset velocity a cada frame
		velocity = Vector2.ZERO

		if abs(diff.x) > abs(diff.y):
			# Move só no eixo X
			velocity.x = speed * sign(diff.x)
		else:
			# Move só no eixo Y
			velocity.y = speed * sign(diff.y)

		move_and_slide()

		# Verifica se está perto o suficiente do alvo para parar
		if global_position.distance_to(target_position) < 1.0:
			is_moving = false
			velocity = Vector2.ZERO
		
func move():
	var enemies = get_tree().get_nodes_in_group("Creatures")
	var occupied_positions = []
	
	for enemy in enemies:
		var area = enemy.get_node("Area2D")
		if(area == self):
			continue
			
		occupied_positions.append(tile_map.local_to_map(global_position))
	
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, true)
	
	var path = astar_grid.get_id_path(
		tile_map.local_to_map(global_position),
		tile_map.local_to_map(playerArea.global_position)
	)
	
	for occupied_position in occupied_positions:
		astar_grid.set_point_solid(occupied_position, false)
		
	occupied_positions = []
	path.pop_front()
	
	if(path.size() == 1):
		print("I have arrived at my destine")
		return
	
	if(path.is_empty()):
		print("Can't find a path")
		return
		
	#global_position = global_position.move_toward(tile_map.map_to_local(path[0]), 0.5)
	target_position = tile_map.map_to_local(path[0])
	
	#global_position = tile_map.map_to_local(path[0])
	#sprite.global_position = global_position
	#sprite.position.y -= 16
	
	is_moving = true
		
		
