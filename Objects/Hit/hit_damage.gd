extends Label

@export var duration := 1.0 
@export var float_speed := 20.0  
var lifetime := 0.0
var type: String

@onready var texture_rect: TextureRect = $TextureRect
var sword_texture = preload("res://HUD/Icons/sword.png")
var book_texture = preload("res://HUD/Icons/book_open.png")
var bow_texture = preload("res://HUD/Icons/bow.png")
var heart_texture = preload("res://HUD/Icons/suit_hearts.png")
var mana_texture = preload("res://HUD/Icons/flask_full.png")

func _ready() -> void:
	if not type:
		texture_rect.texture = sword_texture
		return
		
	if type == "Mana":
		texture_rect.texture = mana_texture
		
	if type == "Heal":
		texture_rect.texture = heart_texture
		
	if type == "Magic":
		texture_rect.texture = book_texture
		
	if type == "Melee":
		texture_rect.texture = sword_texture
		
	if type == "Distance":
		texture_rect.texture = bow_texture
		


func _process(delta: float) -> void:
	position.y -= float_speed * delta
	lifetime += delta
	if lifetime >= duration:
		queue_free()

func _on_auto_delete_timer_timeout():
	queue_free()
