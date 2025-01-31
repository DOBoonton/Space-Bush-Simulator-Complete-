extends Node2D

func _ready():
	self.set_z_index(5)


func _on_animated_sprite_2d_animation_looped():
	queue_free()
