extends CharacterBody2D

@export var Ship : PackedScene
@export var Explosion : PackedScene

var speed = 250
var player = null
var nearPlanet = false
var planet = null
var locked = false
var lockSound = 0.4
var target = ""
var direction = Vector2.ZERO

func _ready():
	$AnimatedSprite2D.play("drive", 3)

func _physics_process(delta):
	if Global.federationAngry == true && $ShipTime.time_left == 0 && player:
		$ShipTime.start()
	
	var check = 0
	for x in $Detection.get_overlapping_bodies():
		if x.is_in_group("PlayerVehicle"):
			check += 1
		if check > 0:
			player = x
	if check == 0:
		player = null

func hit():
	if self.get_parent().is_in_group("One"):
		Global.federationOneHP -= 1
	elif self.get_parent().is_in_group("Two"):
		Global.federationTwoHP -= 1
	elif self.get_parent().is_in_group("Three"):
		Global.federationThreeHP -= 1
	Global.federationAngry = true
	if not self.owner.is_in_group("enemy"):
		self.owner.add_to_group("enemy")

func _on_too_close_detection_body_entered(body):
	for x in $TooCloseDetection.get_overlapping_bodies():
		if x.is_in_group("PlayerVehicle") || x.is_in_group("Obstacle") || (x.is_in_group("enemy") && not x.is_in_group("federation")):
			explode()

func explode():
	var Ex = Explosion.instantiate()
	Ex.position = self.global_position
	Ex.rotation = self.global_rotation
	get_parent().add_child(Ex)
	for x in $BoomDetection.get_overlapping_bodies():
		if x.is_in_group("PlayerVehicle"):
			x.hit()


func shoot():
	if player && Global.federationShips < 30:
		var projectile = Ship.instantiate()
		get_parent().add_child(projectile)
		if $SpawnL.global_position.distance_to(player.global_position) <= 75:
			projectile.global_position = $SpawnR.global_position
		elif $SpawnR.global_position.distance_to(player.global_position) <= 75:
			projectile.global_position = $SpawnL.global_position
		elif $SpawnL.global_position.distance_to(player.global_position) <= $SpawnR.global_position.distance_to(player.global_position):
			projectile.global_position = $SpawnL.global_position
		else:
			projectile.global_position = $SpawnR.global_position
		projectile.global_rotation = global_rotation
		$Summon.play()


func _on_boom_detection_body_entered(body):
	if body.is_in_group("PlayerVehicle") || body.is_in_group("bandit"):
		explode()
		


func _on_cooldown_timeout():
	if player:
		$Engine.play()


func _on_ship_time_timeout():
	shoot()

func die(time):
	$TooCloseDetection/CollisionShape2D.disabled = true
	$BoomDetection/CollisionShape2D.disabled = true
	$Detection/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true
	$WaitTime.wait_time = time
	if $WaitTime.time_left == 0:
		$WaitTime.start()


func _on_wait_time_timeout():
	var Ex = Explosion.instantiate()
	Ex.position = self.global_position
	if player:
		Ex.position = player.global_position
	Ex.rotation = self.global_rotation
	Ex.global_scale = Vector2(15,15)
	get_parent().add_child(Ex)
	Ex.z_index = 5
	$AnimatedSprite2D.hide()
	for x in $BoomDetection.get_overlapping_bodies():
		if x.is_in_group("enemy"):
			x.queue_free()
	$Explosion.play()
