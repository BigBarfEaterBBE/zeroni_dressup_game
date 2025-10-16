extends TextureButton

signal item_selected(slot_name, item_index)

var item_slot_name: String
var item_index: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_item_button_pressed)

func setup(texture: Texture2D, slot_name: String, index: int):
	item_slot_name = slot_name
	item_index = index
	texture_normal = texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_item_button_pressed():
	item_selected.emit(item_slot_name, item_index)
