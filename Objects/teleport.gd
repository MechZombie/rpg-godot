extends Area2D

@export var target_position: Vector2  # posição de destino do teleport

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player": # ou `if body is CharacterBody2D`
		body.global_position = target_position
		
