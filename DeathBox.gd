extends Area2D

func _on_area_entered(area):
	get_tree().reload_current_scene()
