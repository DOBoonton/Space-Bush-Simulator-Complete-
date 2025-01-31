extends CharacterBody2D

@export var Explosion : PackedScene

var MOVE_SPEED = 300
var charged = true
var shooting = false
var help = false
var helpChange = false
var deathCount = 0
var timeTemp = 0
var times = 0
var relicList = []

@onready var raycast = $RayCast2D
@onready var sprite = $AnimatedSprite2D
@onready var laser = $LaserSprite
@onready var chargeTimer = $ChargeTimer

func _ready():
	var loop = Global.relic
	while loop > 0:
		var tempRelic = load("res://Scenes//Bushes/zombieRelic.tscn").instantiate()
		add_child(tempRelic)
		relicList.append(tempRelic)
		tempRelic.global_position = global_position
		tempRelic.global_rotation = global_rotation
		tempRelic.move_local_x(-75 * loop)
		loop -= 1
	await get_tree().process_frame

func _physics_process(delta):
	if Global.crudSol > Global.maxCrudSol:
		Global.crudSol = Global.maxCrudSol
	
	var relics = 1
	for x in relicList:
		
		if relics == 1:
			x.global_position = global_position
			x.global_rotation = global_rotation
			x.move_local_x(-75 * relics)
		else:
			var previous = relicList[relics - 2]
			x.global_position = x.global_position.lerp(previous.global_position, 0.75)
			x.global_rotation = lerp_angle(x.global_rotation, previous.global_rotation * 1.35, 0.15)
			x.move_local_x(-35)
		relics += 1
	
	if charged == true:
		sprite.play("idle")
		laser.play("idleLaser")
	else:
		sprite.play("charging")
		laser.play("chargingLaser")
	var move_vec = Vector2()
	if Global.movement == true:
		if Input.is_action_pressed("keyW"):
			move_vec.y -= 1
		if Input.is_action_pressed("keyS"):
			move_vec.y += 1
		if Input.is_action_pressed("keyA"):
			move_vec.x -= 1
		if Input.is_action_pressed("keyD"):
			move_vec.x += 1
		move_vec = move_vec.normalized()
		move_and_collide(move_vec * MOVE_SPEED * delta)
		
		var look_vec = get_global_mouse_position() - global_position
		global_rotation = atan2(look_vec.y, look_vec.x)
		
		if Input.is_action_just_pressed("shoot"):
			shooting = true
		if Input.is_action_just_released("shoot"):
			shooting = false
		if charged == true && shooting == true && Global.biome != "hq":
			var coll = raycast.get_collider()
			if raycast.is_colliding() and coll.has_method("kill"):
				coll.kill()
				if coll.is_in_group("zombieMars"):
					Global.crudSol += 2
				elif coll.is_in_group("zombieAbyssari"):
					Global.crudSol += 8
				elif coll.is_in_group("zombieAbyssariLarge"):
					Global.crudSol += 48
				elif coll.is_in_group("zombieMagmus"):
					Global.crudSol += 4
				elif coll.is_in_group("zombieMagmusLarge"):
					Global.crudSol += 8
				elif coll.is_in_group("zombieGoldalis"):
					Global.crudSol += 20
				elif coll.is_in_group("zombieRangerPrime"):
					Global.crudSol += 45
			sprite.play("shoot")
			laser.play("shootLaser")
			charged = false
			chargeTimer.start(-1)
			$LazRifle.play(0)
		elif Global.biome == "hq":
			laser.hide()
		else:
			laser.show()
		
		if Input.is_action_pressed("keyEnter"):
			match Global.enterPrompt:
				"ship":
					match Global.tier:
						6:
							Global.bits -= 450
							Global.tier = 4
							$Enter.play()
						5:
							Global.bits -= 450
							Global.tier = 4
							$Enter.play()
						3:
							Global.bits -= 450
							Global.tier = 4
							$Enter.play()
						2:
							Global.bits -= 225
							Global.tier = 3
							$Enter.play()
						1:
							Global.bits -= 100
							Global.tier = 2
							$Enter.play()
					Global.enterPrompt = "shipComplete"
				"RelicEasterEgg":
					Global.relic = 0
					for x in relicList:
						x.queue_free()
					relicList = []
					Global.enterPrompt = "RelicEasterEggComplete"
				"radar1":
					Global.bits -= 35
					Global.radar = 1
					$Enter.play()
					Global.enterPrompt = "radarComplete"
				"radar2":
					Global.bits -= 65
					Global.radar = 2
					$Enter.play()
					Global.enterPrompt = "radarComplete"
				"radar3":
					Global.bits -= 120
					Global.radar = 3
					$Enter.play()
					Global.enterPrompt = "radarComplete"
				"underground":
					if Global.undergroundProg >= 5:
						$Enter.play()
						Global.escape = "underground"
						Global.enterPrompt = "none"
					else:
						Global.relic -= 1
						relicAdd()
						Global.undergroundProg += 1
						
						if Global.undergroundProg == 1:
							Global.tier = 5
							Global.maxSolar = 87500
							Global.currentSolar = Global.maxSolar
							Global.shieldLimit = 6
							Global.shield = Global.shieldLimit
							Global.shieldRecharge = 0.5
						else:
							Global.bits += 140
							Global.currentSolar += 35500
						$Enter.play()
						Global.enterPrompt = "undergroundComplete"
		
		if Input.is_action_pressed("keyH"):
			if helpChange == false:
				if help == false:
					help = true
					$Instructions.show()
				else:
					$Instructions.hide()
					help = false
				$HelpTime.start()
				helpChange = true
				$Help.play()
		
		if Input.is_action_just_pressed("keyB") && deathCount == 0:
			deathCount = 1
			$DeathTime.start()
			$BombTick.pitch_scale = 0.55 + 0.05 * deathCount
			$BombTick.play()
			$BombHold/BombText.show()
		
		if Input.is_action_just_released("keyB") && deathCount <= 9:
			if deathCount > 5:
				Global.playMusic = true
				Global.time = timeTemp
				Global.crisis = true
				timeTemp = 0
				times = 0
				
			deathCount = 0
			$BombDefuse.play()
			$BombHold/BombText.hide()
			$DeathTime.wait_time = 1
			$DeathTime.stop()
		
	
	if global_position.x >= 1136:
		global_position.x = 1136
	elif global_position.x <= 22:
		global_position.x = 22
	if global_position.y >= 618:
		global_position.y = 618
	elif global_position.y <= 22:
		global_position.y = 22
	
	$Instructions.global_position = Vector2(577,324.5)
	$Instructions.global_rotation = 0
	$Instructions.set_z_index(9)
	
	$BombHold.global_rotation = 0
	
	if deathCount >= 6 && deathCount <= 15.5:
		$BombHold/BombText.self_modulate = Color(255,255 - (min(11,deathCount) - 6) * 51,0,max(0,$DeathTime.time_left - 0.2))
	else:
		$BombHold/BombText.self_modulate = Color(255,255,255,max(0,$DeathTime.time_left - 0.2))
	$BombHold/BombText.text = str(16 - deathCount)
	if deathCount > 15.5:
		$BombHold/BombText.show()
		$BombHold/BombText.text = "PRESS H FOR HELP"
	
	if deathCount > 5:
		if Global.time - times != 84 && Global.time - times != -84:
			timeTemp += Global.time - times
			times = Global.time
		if timeTemp >= 84:
			timeTemp = 0
		

func _on_charge_timer_timeout():
	charged = true


func _on_help_time_timeout():
	helpChange = false


func _on_death_time_timeout():
	if deathCount >= 15.5:
		$BombHold/BombText.hide()
		var Ex = Explosion.instantiate()
		Ex.position = self.global_position
		Ex.rotation = self.global_rotation
		get_parent().add_child(Ex)
		$Explosion.play()
		$WaitTime.start()
		$BombHold/BombText.self_modulate = Color(255,255,255,0.95)
		Global.movement = false
		sprite.hide()
		laser.hide()
		deathCount += 0.5
	elif deathCount > 10:
		deathCount += 0.5
		$BombTick.pitch_scale = 0.55 + 0.05 * deathCount
		$BombTick.play()
		$DeathTime.start()
	elif deathCount > 9:
		deathCount += 1
		$BombTick.pitch_scale = 0.55 + 0.05 * deathCount
		$BombTick.play()
		$DeathTime.wait_time = 0.5
		$DeathTime.start()
	elif deathCount == 5:
		Global.playMusic = false
		timeTemp = Global.time
		Global.time = 84
		
		deathCount += 1
		$BombTick.pitch_scale = 0.55 + 0.05 * deathCount
		$DeathTime.start()
		$BombTick.play()
		$BombHold/BombText.show()
	else:
		deathCount += 1
		$BombTick.pitch_scale = 0.55 + 0.05 * deathCount
		$DeathTime.start()
		$BombTick.play()
		$BombHold/BombText.show()

func _on_wait_time_timeout():
	Global.reset()

func relicAdd():
	for x in relicList:
		x.queue_free()
	relicList = []
	var loop = Global.relic
	while loop > 0:
		var tempRelic = load("res://Scenes/Bushes/zombieRelic.tscn").instantiate()
		add_child(tempRelic)
		relicList.append(tempRelic)
		tempRelic.global_position = global_position
		tempRelic.global_rotation = global_rotation
		loop -= 1
