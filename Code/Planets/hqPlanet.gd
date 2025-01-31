extends Area2D

func _on_body_entered(body):
	if body.is_in_group("PlayerVehicle"):
		call_deferred("_change_scene")

func _change_scene():
	Global.vehicleX = global_position.x - 150
	Global.vehicleY = global_position.y - 50
	get_tree().change_scene_to_file("res://Scenes/Surfaces/hq.tscn")
