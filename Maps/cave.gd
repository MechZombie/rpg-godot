extends Node2D

@export var dummy: PackedScene

var dummy_instances = []

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_dummy(Vector2(624, 188))
	spawn_dummy(Vector2(688, 188))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func spawn_dummy(position: Vector2):
	var dummy_instance = dummy.instantiate()
	dummy_instance.position = position
	dummy_instance.info.id = dummy_instances.size() + 1
	dummy_instances.append(dummy_instance)
	
	add_child(dummy_instance)
