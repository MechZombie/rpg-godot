extends Area2D

var tile_map: TileMap
var is_moving: bool = false
var speed:= 80.0

var target_position: Vector2

@onready var ray_cast: RayCast2D = $RayCast2D
@onready var shape: CollisionShape2D = $CollisionShape2D
@onready var sprite: Sprite2D
@onready var player: Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tile_map = get_parent().get_parent().get_node("TileMap")
	sprite = get_parent().get_node("Sprite2D")
	player = get_parent()


func _process(delta: float) -> void:
	if is_moving:
		# Movimento suave até o target
		global_position = global_position.move_toward(target_position, speed * delta)
		sprite.global_position = global_position.move_toward(target_position, speed * delta)
		
		sprite.position.y -= 16
		
		if global_position.distance_to(target_position) < 0.1:
			global_position = target_position
			is_moving = false
		return

	# Detecta input sem diagonais (prioriza horizontal)
	var direction := Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("ui_left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("ui_down"):
		direction = Vector2.DOWN
	elif Input.is_action_pressed("ui_up"):
		direction = Vector2.UP

	if direction != Vector2.ZERO:
		move(direction)



func move(direction: Vector2):
	var tile_size = Vector2(tile_map.tile_set.tile_size)
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	var target_tile: Vector2i = current_tile + Vector2i(int(direction.x), int(direction.y))

	var tile_data: TileData = tile_map.get_cell_tile_data(0, target_tile)
	if not tile_data or tile_data.get_custom_data("walkable") == false:
		return

	ray_cast.target_position = direction * tile_size
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		return

	target_position = tile_map.map_to_local(target_tile)
	is_moving = true
