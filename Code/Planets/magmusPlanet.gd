extends Area2D

func _on_body_entered(body):
	if body.is_in_group("PlayerVehicle"):
		Global.vehicleX = global_position.x - 250
		Global.vehicleY = global_position.y - 250
		call_deferred("_change_scene")

func _change_scene():
	Global.vehicleX = global_position.x - 250
	Global.vehicleY = global_position.y - 250
	get_tree().change_scene_to_file("res://Scenes/Surfaces/magmus.tscn")
