extends Node2D

@export var dummy: PackedScene
@export var creature: PackedScene

var respawn_timer: Timer
@onready var respawn_label: Label = $Label
@onready var title: NinePatchRect = $Title
@onready var background_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D


var dummy_instances = []
var creature_instances = []
var resps = [Vector2(806, 409),  Vector2(443,793), Vector2(244,270)]

# Called when the node enters the scene tree for the first time.
func _ready():
	on_handle_title()
	on_prepare_respawn()
	spawn_creature()

func _process(delta: float) -> void:
	if respawn_timer and respawn_label:
		var remaining = int(respawn_timer.time_left)
		respawn_label.text = "Respawn em: %ds" % remaining
		
		
func on_play_bg():
	background_sound.autoplay = true
	background_sound.play()
		
func on_handle_title():
	title.visible = true
	title.modulate.a = 0.0
	
	# cria um tween para fade in
	var tween := create_tween()
	tween.tween_property(title, "modulate:a", 1.0, 1.0) # alpha 1.0 em 1s
	
	# espera 5 segundos
	await get_tree().create_timer(5).timeout
	
	# cria um tween para fade out
	var tween_out := create_tween()
	tween_out.tween_property(title, "modulate:a", 0.0, 1.0) # alpha 0.0 em 1s
	
	await tween_out.finished
	title.visible = false

	
func on_prepare_respawn():
	respawn_timer = Timer.new()
	respawn_timer.wait_time = 120.0 # 2 minutos
	respawn_timer.one_shot = false
	respawn_timer.autostart = true
	add_child(respawn_timer)
	respawn_timer.timeout.connect(_on_respawn_timeout)
	
	
func _on_respawn_timeout():
	clear_creatures()
	spawn_creature()
	
func clear_creatures():
	for c in creature_instances:
		if is_instance_valid(c):
			c.queue_free()
	creature_instances.clear()

func spawn_creature():
	for resp in resps:
		var creature_instance = creature.instantiate()
		creature_instance.position = resp
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
