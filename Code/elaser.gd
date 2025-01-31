extends Area2D

var speed = 1000
@export var Explosion : PackedScene

func _ready():
	pass
	
func _process(delta):
	position += transform.x * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if is_in_group("banditLaser"):
		if body.is_in_group("PlayerVehicle") || body.is_in_group("federation"):
			body.hit()
			var Ex = Explosion.instantiate()
			Ex.position = self.global_position
			Ex.rotation = self.global_rotation
			get_parent().add_child(Ex)
			queue_free()
	elif is_in_group("federationLaser"):
		if body.is_in_group("PlayerVehicle") || body.is_in_group("bandit"):
			body.hit()
			var Ex = Explosion.instantiate()
			Ex.position = self.global_position
			Ex.rotation = self.global_rotation
			get_parent().add_child(Ex)
			queue_free()
