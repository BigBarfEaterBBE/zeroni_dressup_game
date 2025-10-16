extends Control

const ITEM_BUTTON_SCENE = preload("res://item_button.tscn")
var character: Node2D
var current_character_key: String

@onready var grid = $HBoxContainer/sidebar_panel/optionlist_vbox/ScrollContainer/GridContainer
const CHARACTERS = {
	"thewnini": {
		"base_path":"res://thewnini/",
		"full_path":"res://thewnini/thewnini_body_base.png",
		"icon_path":"res://thewnini/icons/thewnini_body_base.png"
	},
	"binini": {
		"base_path":"res://binini/",
		"full_path":"res://binini/binini_body_base.png",
		"icon_path":"res://binini/icons/binini_body_base.png"
	}
}


const CLOTHING_OPTIONS = {
	"Upper_body_clothes": [
		{
			"icon":"icons/thewnini_upper_clothes_sleep.png",
			"full":"clothes/thewnini_upper_clothes_sleep.png"
			
		},
		{
			"icon":"icons/thewnini_upper_clothes_uniform.png",
			"full":"clothes/thewnini_upper_clothes_uniform.png"
		}
	],
	"Lower_body_clothes": [
		{
			"icon":"icons/thewnini_lower_clothes_apple.png",
			"full":"clothes/thewnini_lower_clothes_apple.png"
			
		},
		{
			"icon":"icons/thewnini_lower_clothes_blueberry.png",
			"full":"clothes/thewnini_lower_clothes_blueberry.png"
		},
		{
			"icon":"icons/thewnini_lower_clothes_cherry.png",
			"full":"clothes/thewnini_lower_clothes_cherry.png"
		},
		{
			"icon":"icons/thewnini_lower_clothes_cranberry.png",
			"full":"clothes/thewnini_lower_clothes_cranberry.png"
		},
		{
			"icon":"icons/thewnini_lower_clothes_uniform.png",
			"full":"clothes/thewnini_lower_clothes_uniform.png"
		}
	],
	"Head_accessory": [
		{
			"full":"clothes/thewnini_accessory_head_apple.png",
			"icon":"icons/thewnini_accessory_head_apple.png"
		},
		{
			"full":"clothes/thewnini_accessory_head_blueberry.png",
			"icon":"icons/thewnini_accessory_head_blueberry.png"
			
		},
		{
			"full":"clothes/thewnini_accessory_head_cherry.png",
			"icon":"icons/thewnini_accessory_head_cherry.png"
		},
		{
			"full":"clothes/thewnini_accessory_head_cranberry.png",
			"icon":"icons/thewnini_accessory_head_cranberry.png"
		},
		{
			"full":"clothes/thewnini_accessory_head_sleep.png",
			"icon":"icons/thewnini_accessory_head_sleep.png"
		}
	]
}

var current_selections: Dictionary = {}

func _ready():
	current_character_key = "thewnini"
	character = get_node("HBoxContainer/character_area/character")
	for slot_name in CLOTHING_OPTIONS.keys():
		current_selections[slot_name] = -1
	_populate_sidebar()

func get_full_texture_path(slot_name: String, item_index: int, type: String) -> String:
	var character_data = CHARACTERS.get(current_character_key)
	if not character_data:
		return ""
	var base_folder = character_data.base_path
	var item_suffix = CLOTHING_OPTIONS[slot_name][item_index][type]
	return base_folder + item_suffix

func _populate_sidebar():
	for slot_name in CLOTHING_OPTIONS.keys():
		var options_list = CLOTHING_OPTIONS[slot_name]
		var target_grid = grid
			
		if target_grid:
			for i in range(options_list.size()):
				var texture_path = get_full_texture_path(slot_name, i, "icon")
				#does this cause problems
				var texture:Texture2D = null
				
				# 1. Only attempt to load if the path is NOT the null placeholder
				if texture_path != null:
					texture = load(texture_path) 
				
				var button_texture: Texture2D
				
				# 2. Check if the result of the load is NOT a valid instance
				if is_instance_valid(texture):
					button_texture = texture
				else:
					# Debug output: If texture_path was null, it's the 'None' item. 
					# If texture_path was a string, it was a failed load.
					if texture_path != null:
						print("FAILED to load texture at path: ", texture_path) # <-- This will now print the bad path
					else:
						# This handles the intended 'None' (i=0) item
						print("Setting 'None' icon for index 0")

					button_texture = preload("res://thewnini/clothes/thewnini_accessory_head_cranberry.png") 
					

					
				if ITEM_BUTTON_SCENE == null:
					print("ERROR: ITEM_BUTTON_SCENE is null. Check preload path!")
					return
				var button_instance = ITEM_BUTTON_SCENE.instantiate()
				if not is_instance_valid(button_instance):
					print("ERROR: Failed to instantiate item button for index ", i)
					continue
				button_instance.setup(button_texture, slot_name, i)
				button_instance.item_selected.connect(_on_item_selected)
				target_grid.add_child(button_instance)
				print("   -> Added button for index ", i) 
		

func _on_item_selected(slot_name:String, item_index:int):
	var current_index = current_selections.get(slot_name, -1)
	var target_sprite = character.get_node(slot_name)
	var new_texture: Texture2D = null
	var new_selection_index:int
	if item_index == current_index:
		new_selection_index = -1
	else:
		new_selection_index = item_index
		var texture_path = get_full_texture_path(slot_name, item_index, "full")
		
		if texture_path != "":
			new_texture = load(texture_path)
	current_selections[slot_name] = new_selection_index
	if is_instance_valid(target_sprite) and target_sprite is Sprite2D:
		target_sprite.texture = new_texture
		

func change_item(slot_name: String, direction:int):
	#get current index and list of options for slot
	var current_index = current_selections.get(slot_name,0)
	var options_list = CLOTHING_OPTIONS.get(slot_name, [])
	var options_count = options_list.size()
	if options_count == 0:
		return
	
	#calculate the new option index + using % to wrap around list
	var new_index = (current_index + direction) % options_count
	current_selections[slot_name] = new_index
	var item_data = options_list[new_index]
	var texture_path = item_data.full
	var new_texture: Texture2D = null
	if texture_path != null:
		new_texture = load(texture_path)
	var target_sprite = character.get_node(slot_name)
	if is_instance_valid(target_sprite) and target_sprite is Sprite2D:
		target_sprite.texture = new_texture
		print("Set " + slot_name + " to index " + str(new_index))
		
