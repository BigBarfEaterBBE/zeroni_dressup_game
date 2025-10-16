extends Node2D

const CHARACTER_SELECT_SCREEN = preload("res://character_select.tscn")
const CUSTOMIZER_SCENE = preload("res://character_customizer.tscn")

var customizer_instance: Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var selector_instance = CHARACTER_SELECT_SCREEN.instantiate()
	add_child(selector_instance)
	selector_instance.character_selected.connect(_start_customizer)

func _start_customizer(selected_key: String):
	customizer_instance = CUSTOMIZER_SCENE.instantiate()
	add_child(customizer_instance)
	customizer_instance.current_character_key = selected_key
	customizer_instance.load_initial_character()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
