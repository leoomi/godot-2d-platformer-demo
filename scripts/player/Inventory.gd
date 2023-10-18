class_name Inventory
extends Node

@export var long_jump = false
@export var wall_slide = false
@export var wall_jump = false
@export var double_jump = false

func save() -> Dictionary:
	var save_dict = {
		"long_jump": long_jump,
		"wall_slide": wall_slide,
 		"wall_jump": wall_jump,
		"double_jump": double_jump
	}
	
	return save()
