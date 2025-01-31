extends CharacterBody2D

@export var Laser : PackedScene
@export var Explosion : PackedScene

var speed = 250
var player = null
var detection = 0
var eHP = 3
var nearPlanet = false
var planet = null
var locked = false
var lockSound = 0.4
var target = ""

func _ready():
	$AnimatedSprite2D.play("Drive", 1.5)

func _physics_process(delta):
	velocity = Vector2.ZERO
	
	if eHP <= 0:
		explode()
	
	for x in $Detection.get_overlapping_bodies():
		if x.is_in_group("PlayerVehicle"):
			player = x
			if global_position.distance_to(player.global_position) <= 250:
				speed = -100
				if locked == true && $Cooldown.time_left == 0:
					shoot()
					$Cooldown.start()
				$AnimatedSprite2D.play("Reverse", 1)
			elif global_position.distance_to(player.global_position) <= 450:
				speed = 0
				if locked == true && $Cooldown.time_left == 0:
					shoot()
					$Cooldown.start()
				$AnimatedSprite2D.play("Idle", 1)
			elif global_position.distance_to(player.global_position) <= 750:
				speed = 600
				$AnimatedSprite2D.play("Drive", 1.5)
			else:
				speed = 800
				$AnimatedSprite2D.play("Drive", 3)
	
	var closest = 1000000
	for x in $Detection.get_overlapping_areas():
		if global_position.distance_to(x.global_position) < closest:
			closest = global_position.distance_to(x.global_position)
			planet = x
			
		if closest < 1000000 && x.is_in_group("obstacle"):
			nearPlanet = true
			speed = -100
			$AnimatedSprite2D.play("Reverse", 1)
		else:
			nearPlanet = false
	
	if eHP == 1  && player && is_in_group("CEO"):
		velocity = global_position.direction_to(player.global_position) * -800
		$AnimatedSprite2D.play("Drive", 3)
		if nearPlanet == false:
			look_at(global_position + velocity)
	elif eHP == 1  && player:
		velocity = global_position.direction_to(player.global_position) * 800
		$AnimatedSprite2D.play("Drive", 3)
		look_at(player.global_position)
	elif player:
		velocity = global_position.direction_to(player.global_position) * speed
		if nearPlanet == false:
			look_at(player.global_position)
	elif planet && eHP > 1:
			velocity = global_position.direction_to(planet.global_position) * speed
			look_at(planet.global_position)
	move_and_slide()

func hit():
	eHP -= 1

func _on_too_close_detection_body_entered(body):
	for x in $TooCloseDetection.get_overlapping_bodies():
		if x.is_in_group("PlayerVehicle") || x.is_in_group("Obstacle") || (x.is_in_group("enemy") && not x.is_in_group("bandit")):
			explode()

func explode():
	var Ex = Explosion.instantiate()
	Ex.position = self.global_position
	Ex.rotation = self.global_rotation
	get_parent().add_child(Ex)
	$Explosion.play()
	for x in $BoomDetection.get_overlapping_bodies():
		if x.is_in_group("enemy"):
			x.queue_free()
		elif x.is_in_group("PlayerVehicle"):
			x.boom()
	queue_free()
	

func _on_locking_time_timeout():
	locked = true

func shoot():
	var projectile = Laser.instantiate()
	get_parent().add_child(projectile)
	projectile.add_to_group("banditLaser")
	projectile.global_position = $Laser.global_position
	projectile.global_rotation = global_rotation
	$Cooldown.start()
	$LaserSFX.play()


func _on_lock_sound_t_ime_timeout():
	$Radar.play()
	$LockSoundTime.wait_time -= 0.05
	if $LockSoundTime.wait_time <= 0.075:
		$LockSoundTime.wait_time = 0.075
	if target != "":
		$LockSoundTime.start()


func _on_boom_detection_body_entered(body):
	if body.is_in_group("PlayerVehicle") || body.is_in_group("federation"):
		explode()


func _on_shoot_detection_body_entered(body):
	if locked == false && target == "":
		for x in body.get_groups():
			match x:
				"PlayerVehicle":
					$LockingTime.start()
					$LockSoundTime.start()
					target = "player"
					return
				"federation":
					$LockingTime.start()
					$LockSoundTime.start()
					target = "federation"
					return


func _on_shoot_detection_body_exited(body):
	if (body.is_in_group("PlayerVehicle") && target == "player") || (body.is_in_group("federation") && target == "federation"):
		$LockingTime.stop()
		$LockSoundTime.stop()
		locked = false
		$LockSoundTime.wait_time = 0.4
		target = ""
		
