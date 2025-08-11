extends Node2D

@export var dummy: PackedScene
@export var creature: PackedScene

var dummy_instances = []
var creature_instances = []

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_creature()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_creature():
	var spawn = get_node("Respawn")
	var creature_instance = creature.instantiate()
	creature_instance.position = spawn.position
	creature_instance.info.id = creature_instances.size() + 1
	creature_instances.append(creature_instance)
	
	add_child(creature_instance)

func spawn_dummy(position: Vector2):
	var dummy_instance = dummy.instantiate()
	dummy_instance.position = position
	dummy_instance.info.id = creature_instances.size() + 1
	creature_instances.append(dummy_instance)
	
	add_child(dummy_instance)


func _input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.
