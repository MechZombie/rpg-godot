extends Resource

class_name PlayerPassives


@export var activated: Array[Passive] = []
@export var deactivated: Array[Passive] = []

signal on_exec(passive)

func on_call_spell(passive: Passive):
	on_exec.emit(passive)
