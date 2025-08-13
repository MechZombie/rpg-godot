extends Panel

@onready var texture_button: TextureButton = $TextureButton
@onready var label: Label = $Label

var texture
var label_value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible = false
	
	if texture:
		texture_button.texture_normal = texture
		
	if(label_value):
		label.text = str(label_value)
		label.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
