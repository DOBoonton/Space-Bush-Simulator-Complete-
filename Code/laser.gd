extends Area2D

var speed = 3250
@export var Explosion : PackedScene

func _ready():
	pass
	
func _process(delta):
	position += transform.x * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_body_entered(body):
	if body.is_in_group("enemy") || body.is_in_group("federation") || body.is_in_group("pirate"):
		body.hit()
		var Ex = Explosion.instantiate()
		Ex.position = self.global_position
		Ex.rotation = self.global_rotation
		get_parent().add_child(Ex)
		queue_free()


func _on_area_entered(area):
	if area.is_in_group("missile"):
		area.queue_free()
		var Ex = Explosion.instantiate()
		Ex.position = self.global_position
		Ex.rotation = self.global_rotation
		get_parent().add_child(Ex)
		queue_free()
