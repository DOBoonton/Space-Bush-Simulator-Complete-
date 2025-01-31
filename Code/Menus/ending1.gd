extends Control

func _process(delta):
	if Input.is_action_pressed("keyEnter"):
		get_tree().change_scene_to_file("res://Scenes/Menus/title.tscn")
