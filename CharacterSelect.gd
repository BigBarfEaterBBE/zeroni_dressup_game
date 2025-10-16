extends Control

signal character_selected(key:String)

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in $CenterContainer/HBoxContainer.get_children():
		if child is TextureButton:
			child.pressed.connect(_on_character_button_pressed.bind(child.name))

func _on_character_button_pressed(key: String):
	character_selected.emit(key)
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
