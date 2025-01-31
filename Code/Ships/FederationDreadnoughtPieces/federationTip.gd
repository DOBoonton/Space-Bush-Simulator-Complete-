extends CharacterBody2D

@export var Missile : PackedScene #replace with shoop da whoop
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
	if Global.federationAngry == true && $MissileTime.time_left == 0 && player:
		$MissileTime.start()
	
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
		if x.is_in_group("enemy"):
			x.queue_free()
		elif x.is_in_group("PlayerVehicle"):
			x.boom()
	$Explosion.play()

func shoot():
	if player && Global.federationShips < 15:
		var projectile = Missile.instantiate()
		get_parent().add_child(projectile)
		projectile.global_position = $Spawn.global_position
		projectile.global_rotation = global_rotation
		projectile.add_to_group("federationLaser")
		if (is_in_group("One") && Global.federationOneHP <= 150) || (is_in_group("Two") && Global.federationTwoHP <= 150) || (is_in_group("Three") && Global.federationThreeHP <= 150):
			var projectileTwo = Missile.instantiate()
			get_parent().add_child(projectileTwo)
			projectileTwo.global_position = $Spawn2.global_position
			projectileTwo.global_rotation = global_rotation
			projectileTwo.add_to_group("federationLaser")
			var projectileThree = Missile.instantiate()
			get_parent().add_child(projectileThree)
			projectileThree.global_position = $Spawn3.global_position
			projectileThree.global_rotation = global_rotation
			projectileThree.add_to_group("federationLaser")
		$Missile.play()


func _on_boom_detection_body_entered(body):
	if body.is_in_group("PlayerVehicle") || body.is_in_group("bandit"):
		explode()
		


func _on_cooldown_timeout():
	if player:
		$Engine.play()

func die(time):
	$TooCloseDetection/CollisionShape2D.disabled = true
	$BoomDetection/CollisionShape2D.disabled = true
	$Detection/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true
	$CollisionShape2D2.disabled = true
	$WaitTime.wait_time = time
	if $WaitTime.time_left == 0:
		$WaitTime.start()


func _on_wait_time_timeout():
	var Ex = Explosion.instantiate()
	Ex.position = self.global_position
	Ex.rotation = self.global_rotation
	Ex.global_scale = Vector2(15,15)
	get_parent().add_child(Ex)
	Ex.z_index = 5
	$AnimatedSprite2D.hide()
	for x in $BoomDetection.get_overlapping_bodies():
		if x.is_in_group("enemy"):
			x.queue_free()
	$Explosion.play()


func _on_missile_time_timeout():
	shoot()
