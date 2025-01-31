extends CharacterBody2D

@export var Laser : PackedScene
@export var Explosion : PackedScene

@onready var gearTime = $GearboxTime 
@onready var fuelTime = $FuelTime 
@onready var sprite = $AnimatedSprite2D
@onready var tankHUD = $Hud/Gear/SolarCount
@onready var crudHUD = $Hud/Gear/CrudSolCount
@onready var timeHUD = $Hud/Gear/TimeCount

var rotation_speed = 1.5  # turning speed in radians/sec
var wheel_base = 70
var steering_angle = 15
var engine_power = 900
var friction = -55
var drag = -0.06
var braking = -450
var max_speed_reverse = 250
var slip_speed = 400
var traction_fast = 2.5
var traction_slow = 10
var shootL = true
var shootR = false
var fuel = false
var globalTurn = 0
var hasF = false

var gear = 0
var gearChange = false

var acceleration = Vector2.ZERO
var steer_direction

var sound = true
var speed = 0

var target = 0
var radarCD = false

var help = false
var helpChange = false

var deathCount = 0
var timeTemp = 0
var times = 0

var relicList = []

func _ready():
	Global.enterPrompt = "empty"
	$TextNode/Text.hide()
	global_position.x = Global.vehicleX
	global_position.y = Global.vehicleY
	rotation = 3
	
	relicAdd()
	
	if Global.crudSol > 0 && Global.mercy == true:
		Global.mercy = false
	
	$ShieldTime.wait_time = 360 * Global.shieldRecharge
	
	if Global.shield < Global.shieldLimit:
		$ShieldTime.start()
	applyShields()
	await get_tree().process_frame

func _physics_process(delta):
	if Global.pause == false:
		var relics = 1
		for x in relicList:
			
			if relics == 1:
				x.global_position = global_position
				x.global_rotation = global_rotation
				x.move_local_x(-52.5 * relics)
			else:
				var previous = relicList[relics - 2]
				x.global_position = x.global_position.lerp(previous.global_position, 0.75)
				x.global_rotation = lerp_angle(x.global_rotation, previous.global_rotation * 1.35, 0.15)
				x.move_local_x(-10.5)
			relics += 1
		
		if Global.currentSolar > Global.maxSolar:
			Global.currentSolar = Global.maxSolar
		
		if Global.crudSol > 0:
			hasF = true
		else:
			hasF = false
		
		acceleration = Vector2.ZERO
		get_input()
		$Laser.look_at(get_global_mouse_position())
		$Laser2.look_at(get_global_mouse_position())
		apply_friction(delta)
		calculate_steering(delta)
		velocity += acceleration * delta
		move_and_slide()
		
		if global_position.x >= 160408 || global_position.x <= 0 || global_position.y >= 107896 || global_position.y <= 0:
			if Global.tier in [4,6]:
				Global.escape = "travel"
			elif Global.mercy == false:
				Global.mercy = true
				$MercyTime.start()
				$TextNode/Text.text = "PLEASE RETURN TO THE SYSTEM OR YOU WILL BE LAID OFF"
				$TextNode/Text.show()
				$TextTimer.start()
				$SpeechStatic.play()
				$Speech.play()
				$StaticTime.start()
		else:
			if Global.mercy == true && Global.currentSolar > 0:
				Global.mercy = false
				$MercyTime.stop()
				deathCount = 0
				$BombDefuse.play()
				$BombHold/BombText.hide()
				$DeathTime.wait_time = 1
				$DeathTime.stop()
				get_parent().RevertMercy()
			
		if (global_position.x >= 175000 || global_position.x <= -15000 || global_position.y >= 115000 || global_position.y <= -15000) && deathCount < 15.5:
			boom()
			deathCount = 15.5
		
		Global.vehicleX = global_position.x
		Global.vehicleY = global_position.y
		
		match Global.tier:
			1:
				$Collision1.disabled = false
				$Collision2.disabled = true
				$Collision3.disabled = true
				$Collision4.disabled = true
				$Collision5.disabled = true
				$Collision6.disabled = true
			2:
				$Collision1.disabled = true
				$Collision2.disabled = false
				$Collision3.disabled = true
				$Collision4.disabled = true
				$Collision5.disabled = true
				$Collision6.disabled = true
			3:
				$Collision1.disabled = true
				$Collision2.disabled = true
				$Collision3.disabled = false
				$Collision4.disabled = true
				$Collision5.disabled = true
				$Collision6.disabled = true
			4:
				$Collision1.disabled = true
				$Collision2.disabled = true
				$Collision3.disabled = true
				$Collision4.disabled = false
				$Collision5.disabled = true
				$Collision6.disabled = true
			5:
				$Collision1.disabled = true
				$Collision2.disabled = true
				$Collision3.disabled = true
				$Collision4.disabled = true
				$Collision5.disabled = false
				$Collision6.disabled = true
			6:
				$Collision1.disabled = true
				$Collision2.disabled = true
				$Collision3.disabled = true
				$Collision4.disabled = true
				$Collision5.disabled = true
				$Collision6.disabled = false
		
		speed = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
		if speed >= 20000:
			$LudicrousSpeed.show()
		else:
			$LudicrousSpeed.hide()
		$Hud/Anchor/ColorRect.set_color(Color(255,0,255,(min(speed,25000) * 1.0) / 250000))
		$Hud/Anchor.global_rotation_degrees = 0
		$Hud/Anchor.global_position = global_position
		
		$Instructions.global_position = global_position
		$Instructions.global_rotation = 0
		
#		$Shield.modulate = Color(r,g,b,min(0.8,speed)) #make a system to set the colors
	
func apply_friction(delta):
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	match gear:
		2:
			drag_force = Vector2.ZERO
		-1:
			drag_force = drag_force * 25
		3:
			acceleration -= drag_force * 1.1
	acceleration += drag_force + friction_force
	if Global.currentSolar < 0:
		Global.currentSolar = 0
		acceleration = Vector2(0,0)
	if velocity.x > 50000:
		velocity.x = 50000
	if velocity.x < -50000:
		velocity.x = -50000
	if velocity.y > 50000:
		velocity.y = 50000
	if velocity.y < -50000:
		velocity.y = -50000
	
	match gear:
		-1:
			if hasF == true && Global.tier != 5:
				sprite.play(str(Global.tier) + "ReverseF", 1)
			else:
				sprite.play(str(Global.tier) + "Reverse", 1)
			$Hud/Gear.play("Reverse")
		0:
			if hasF == true && Global.tier != 5:
				sprite.play(str(Global.tier) + "IdleF", 1)
			else:
				sprite.play(str(Global.tier) + "Idle", 1)
			$Hud/Gear.play("Neutral")
		1:
			if hasF == true && Global.tier != 5:
				sprite.play(str(Global.tier) + "DriveF", 1.5)
			else:
				sprite.play(str(Global.tier) + "Drive", 1.5)
			$Hud/Gear.play("Drive")
		2:
			if hasF == true && (Global.tier != 4 && Global.tier != 5):
				sprite.play(str(Global.tier) + "DriveF", 3)
			elif hasF == true && Global.tier == 4:
				sprite.play(str(Global.tier) + "SportF", 3)
			elif hasF == false && Global.tier == 4:
				sprite.play(str(Global.tier) + "Sport", 3)
			else:
				sprite.play(str(Global.tier) + "Drive", 3)
			$Hud/Gear.play("Sport")
		3:
			if Global.tier == 5:
				sprite.play(str(Global.tier) + "Ludicrous", 5)
				$Hud/Gear.play("Ludicrous")
		
		
	if Global.currentSolar <= 0:
		if hasF == true && Global.tier != 5:
			sprite.play(str(Global.tier) + "IdleF", 1)
		else:
			sprite.play(str(Global.tier) + "Idle", 1)
		if Global.mercy == false:
			Global.mercy = true	
			$MercyTime.start()
	tankHUD.hide()
	crudHUD.hide()
	timeHUD.hide()
	$Hud/Gear/QuotaCount.hide()
	$Hud/Gear/BitsCount.hide()
	$Hud/Radar.hide()
	$Hud/Gear/Version.hide()
	$Hud/Gear/BossHP.hide()
	if Global.shield < Global.shieldLimit && $ShieldTime.time_left == 0:
		$ShieldTime.start()
	if Global.shield < Global.shieldLimit && $ShieldTime.time_left != 0:
		$Hud/Gear/ShieldRecharge.show()
		$Hud/Gear/ShieldRecharge.value = $ShieldTime.time_left / $ShieldTime.wait_time
	else:
		$Hud/Gear/ShieldRecharge.hide()
	$BombHold.global_rotation = 0
	
	if deathCount >= 6 && deathCount <= 15.5:
		$BombHold/BombText.self_modulate = Color(255,255 - (min(11,deathCount) - 6) * 51,0,max(0,$DeathTime.time_left - 0.2))
	else:
		$BombHold/BombText.self_modulate = Color(255,255,255,max(0,$DeathTime.time_left - 0.2))
	$BombHold/BombText.text = str(16 - deathCount)
	if deathCount > 15.5:
		$BombHold/BombText.show()
		$BombHold/BombText.text = "PRESS H FOR HELP"
		$BombHold/BombText.self_modulate = Color(255,255,255,0.95)
	
	if deathCount > 5:
		if Global.time - times != 84 && Global.time - times != -84:
			timeTemp += Global.time - times
			times = Global.time
		if timeTemp >= 84:
			timeTemp = 0
	
func get_input():
	if Input && Global.enterPrompt == "surrenderComplete":
		Global.surrender = null
		$TextNode/Text.text = "THAT WAS YOUR LAST CHANCE!"
		$SpeechStatic.play()
		$SpeechGood.play()
		$StaticTime.start()
		$TextNode/Text.show()
		$TextTimer.start()
		Global.enterPrompt = "empty"
	if Global.movement == true:
		
		var turn = Input.get_axis("keyA", "keyD")
		steer_direction = turn * deg_to_rad(steering_angle)
		
		if Input.is_action_pressed("gear_up") && gearChange == false:
			gear -= 1
			if gear < -1 && Global.tier >= 2:
				gear = -1
			elif gear < 0 && Global.tier == 1:
				gear = 0
			gearChange = true
			gearTime.start()
			
			if Global.enterPrompt == "surrender" && gear == 0 && Global.surrender != null:
				$TextNode/Text.text = "NOW SURRENDER YOURSELF!"
				$SpeechStatic.play()
				$SpeechGood.play()
				$StaticTime.start()
				$TextNode/Text.show()
				$TextTimer.start()
				Global.enterPrompt = "surrenderComplete"
			
		if Input.is_action_pressed("gear_down") && gearChange == false:
			gear += 1
			if gear > 3 && Global.tier == 5:
				gear = 3
			elif gear > 2 && Global.tier in [3,4,6]:
				gear = 2
			elif gear > 1 && Global.tier in [1,2]:
				gear = 1
			gearChange = true
			gearTime.start()
			
			if Global.enterPrompt == "surrender" && gear == 0 && Global.surrender != null:
				$TextNode/Text.text = "NOW SURRENDER YOURSELF!"
				$SpeechStatic.play()
				$SpeechGood.play()
				$StaticTime.start()
				$TextNode/Text.show()
				$TextTimer.start()
				Global.enterPrompt = "surrenderComplete"
			
		if Input.is_action_pressed("keyW") && Global.currentSolar > 0:
			$Ludicrous.pitch_scale = 0.6
			if gear == 2:
				acceleration = (transform.x * engine_power)
				if fuel == false:
					fuelTime.start()
					fuel = true
			else:
				acceleration = (transform.x * engine_power) * gear
				if fuel == false:
					fuelTime.start()
					fuel = true
			if gear in [-1,0,1,2] && sound == true:
				$Engine.play()
			elif gear == 3 && sound == true:
				$Ludicrous.play()
				$Ludicrous.pitch_scale = 0.6 + min(1.4,speed / 53571)
			match gear:
				0:
					$SoundTime.wait_time = 0.5
				1:
					$SoundTime.wait_time = 0.2
				2:
					$SoundTime.wait_time = 0.15
				3:
					$SoundTime.wait_time = 0.10
				-1:
					$SoundTime.wait_time = 0.35
			
			if sound == true:
				$SoundTime.start()
				sound = false
		
		if Input.is_action_pressed("keyS"):
			if velocity.x > 0:
				acceleration = transform.x * braking
				
		if Input.is_action_pressed("shoot"):
			if Global.tier == 5 && gear != 3:
				fire()
		
		if Input.is_action_pressed("keyLeft") && radarCD == false:
			radarCD = true
			target += 1
			if Global.radar == 0 && target > 3:
				target = 0
			elif Global.radar == 1 && target > 6:
				target = 0
			elif Global.radar == 2 && target > 8:
				target = 0
			elif Global.radar == 3 && target > 10:
				target = 0
			$Radar.play()
			$RadarCooldown.start()
		
		if Input.is_action_pressed("keyRight") && radarCD == false:
			radarCD = true
			target -= 1
			if Global.radar == 0 && target < 0:
				target = 3
			elif Global.radar == 1 && target < 0:
				target = 6
			elif Global.radar == 2 && target < 0:
				target = 8
			elif Global.radar == 3 && target < 0:
				target = 10
			$Radar.play()
			$RadarCooldown.start()
		
		if Input.is_action_pressed("keyEnter"):
			match Global.enterPrompt:
				"federation":
					$TextNode/Text.text = "THANKS FOR YOUR TRIBUTE. WE REWARD LOYAL CITIZENS!"
					$TextNode/Text.show()
					$TextTimer.start()
					$SpeechStatic.play()
					$SpeechGood.play()
					$StaticTime.start()
					if Global.relic < Global.relicLimit:
						Global.relic += 1
						relicAdd()
					Global.enterPrompt = "empty"
				"surrender":
					if gear == 0 && Global.surrender != null:
						$TextNode/Text.text = "AN ENVOY IS COMING FOR YOU! DON'T DO ANYTHING"
						$TextNode/Text.show()
						$TextTimer.start()
						$SpeechStatic.play()
						$Speech.play()
						$StaticTime.start()
						Global.surrender = true #add code for the ship to come close and start prison ending
						Global.enterPrompt = "empty"
		
		if Input.is_action_just_pressed("keyQ") && Global.debug == true: #use this to test stuff on the go
			#testing tiers and au mileage
			Global.tier += 1
			if Global.tier >= 7:
				Global.tier = 1
			print(Global.tier)
			gearChange = true
			gear = 0
			gearTime.start()
			Global.currentSolar = Global.maxSolar
			Global.shield = Global.shieldLimit
			$ShieldTime.stop()
			applyShields()
#			match Global.tier: # this bugs out codes
#				1:
#					Global.maxSolar = 3000
#					Global.currentSolar = Global.maxSolar
#					Global.maxCrudSol = 300
#					Global.relicLimit = 1
#					Global.shieldLimit = 2
#					Global.shieldRecharge = 0.25
#				2:
#					Global.maxSolar = 12500
#					Global.currentSolar = Global.maxSolar
#					Global.maxCrudSol = 800
#					Global.relicLimit = 1
#					Global.shieldLimit = 3
#					Global.shieldRecharge = 0.25
#				3:
#					Global.maxSolar = 42500
#					Global.currentSolar = Global.maxSolar
#					Global.maxCrudSol = 3000
#					Global.relicLimit = 1
#					Global.shieldLimit = 5
#					Global.shieldRecharge = 0.1875
#				4:
#					Global.maxSolar = 187500
#					Global.currentSolar = Global.maxSolar
#					Global.maxCrudSol = 15000
#					Global.relicLimit = 1
#					Global.shieldLimit = 10
#					Global.shieldRecharge = 0.0625
#				5:
#					Global.maxSolar = 87500
#					Global.currentSolar = Global.maxSolar
#					Global.maxCrudSol = 1500
#					Global.relicLimit = 2
#					Global.shieldLimit = 6
#					Global.shieldRecharge = 0.125
#				6:
#					Global.maxSolar = 2500000
#					Global.currentSolar = Global.maxSolar
#					Global.maxCrudSol = 4500
#					Global.relicLimit = 1
#					Global.shieldLimit = 5
#					Global.shieldRecharge = 0.125
		
		if Input.is_action_pressed("keyE") && radarCD == false:
			Global.radar += 1
			if Global.radar > 3:
				Global.radar = 0
			radarCD = true
			$RadarCooldown.start()
			print(Global.radar)
		
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
		
		if Input.is_action_just_pressed("keyB") && deathCount == 0 && Global.mercy == false:
				deathCount = 1
				$DeathTime.start()
				$BombTick.pitch_scale = 0.55 + 0.05 * deathCount
				$BombTick.play()
				$BombHold/BombText.show()
			
		if Input.is_action_just_released("keyB") && deathCount <= 9 && Global.mercy == false:
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

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = rear_wheel.direction_to(front_wheel)
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
	rotation = new_heading.angle()
	
	new_heading = 0
	$Hud/Gear.global_position = Vector2(539.5,278) + position
	$Hud/Gear.global_rotation_degrees = 0
	$TextNode.global_position = Vector2(-576,139) + position
	$TextNode.global_rotation_degrees = 0
	match target:
			0:
				Global.radarTarget = "mars"
			1:
				Global.radarTarget = "hq"
			2:
				Global.radarTarget = "shop"
			3:
				Global.radarTarget = "harsh"
			4:
				Global.radarTarget = "goldalis"
			5:
				Global.radarTarget = "rangerprime"
			6:
				Global.radarTarget = "federation"
			7:
				Global.radarTarget = "abandonedhq"
			8:
				Global.radarTarget = "pirate"
			9:
				Global.radarTarget = "bandits"
			10:
				Global.radarTarget = "harshl"

func fire():
	if shootR == true && $Cooldown.time_left <= 0.375:
		shootR = false
		var R = Laser.instantiate()
		owner.add_child(R)
		R.transform = $Laser2.global_transform
		$Cooldown2.start()
		$LaserSFX.play()
	elif shootL == true && $Cooldown2.time_left <= 0.375:
		shootL = false
		shootR = true
		$Cooldown.start()
		var L = Laser.instantiate()
		owner.add_child(L)
		L.transform = $Laser.global_transform
		$Cooldown.start()
		$LaserSFX.play()

func _on_gearbox_time_timeout():
	gearChange = false

func _on_cooldown_timeout():
	shootL = true

func _on_fuel_time_timeout():
	Global.currentSolar -= 10
	match gear:
		2:
			Global.currentSolar -= 15
		3:
			Global.currentSolar -= 150
		0:
			Global.currentSolar += 8
		-1:
			Global.currentSolar += 5
	fuel = false

func _on_sound_time_timeout():
	sound = true

func _on_radar_cooldown_timeout():
	radarCD = false

func _on_cooldown_2_timeout():
	shootR = true

func _on_help_time_timeout():
	helpChange = false

func _on_death_time_timeout():
	if deathCount >= 15.5:
		$BombHold/BombText.hide()
		boom()
		$BombHold/BombText.self_modulate = Color(255,255,255,0.95)
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
	elif deathCount == 5 && Global.mercy == false:
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

func _on_mercy_time_timeout():
	deathCount = 1
	$DeathTime.start()
	$BombTick.pitch_scale = 0.55 + 0.05 * deathCount
	$BombTick.play()
	$BombHold/BombText.show()

func relicAdd():
	for x in relicList:
		x.queue_free()
	relicList = []
	var loop = Global.relic
	while loop > 0:
		var tempRelic = load("res://Scenes/Bushes/zombieRelic.tscn").instantiate()
		add_child(tempRelic)
		relicList.append(tempRelic)
		tempRelic.scale = Vector2(0.3,0.3)
		tempRelic.global_position = global_position
		tempRelic.global_rotation = global_rotation
		loop -= 1

func boom():
	velocity = Vector2.ZERO
	$Explosion.play()
	var Ex = Explosion.instantiate()
	Ex.position = self.global_position
	Ex.rotation = self.global_rotation
	get_parent().add_child(Ex)
	if $WaitTime.time_left == 0:
		$WaitTime.start()
	Global.playMusic = false
	Global.time = 84
	Global.movement = false
	sprite.hide()
	$Hud.hide()
	$Collision1.disabled = true
	$Collision2.disabled = true
	$Collision3.disabled = true
	$Collision4.disabled = true
	$Collision5.disabled = true
	$Collision6.disabled = true

func hit():
	$ShipDamaged.play()
	if Global.damaged == true:
		boom()
	else:
		if $ShieldTime.time_left == 0:
			$ShieldTime.start()
		Global.shield -= 1
		if Global.shield == 0:
			Global.damaged = true
			$ShieldTime.stop()
		applyShields()
			

func _on_shield_time_timeout():
	Global.shield += 1
	applyShields()
	$ShieldSFX.play()


func _on_text_timer_timeout():
	$TextNode/Text.hide()

func offer(offer):
	match offer:
		"federation":
			$TextNode/Text.text = "WE ASK YOU AS A CITIZEN TO OFFER 7.5 CrudSol AS TRIBUTE"
			$TextNode/Text.show()
			$TextTimer.start()
			$SpeechStatic.play()
			$Speech.play()
			$StaticTime.start()
		"greeting":
			$TextNode/Text.text = "DON'T FORGET ABOUT CosmOil'S TRIBUTE"
			$TextNode/Text.show()
			$TextTimer.start()
			$SpeechStatic.play()
			$Speech.play()
			$StaticTime.start()
		"surender":
			$TextNode/Text.text = "IF YOU ENTER NEUTRAL GEAR AND SURRENDER, WE MAY SPARE YOU"
			$TextNode/Text.show()
			$TextTimer.start()
			$SpeechStatic.play()
			$Speech.play()
			$StaticTime.start()
		"nosurrender":
			$TextNode/Text.text = "THAT WAS YOUR LAST CHANCE!"
			$SpeechStatic.play()
			$SpeechGood.play()
			$StaticTime.start()
			$TextNode/Text.show()
			$TextTimer.start()

func _on_static_time_timeout():
	$SpeechStatic.play()

func applyShields():
	$Shield/Shield1.play("hide")
	$Shield/Shield2.play("hide")
	$Shield/Shield3.play("hide")
	$Shield/Shield4.play("hide")
	$Shield/Shield5.play("hide")
	$Shield/Shield6.play("hide")
	$Shield/Shield7.play("hide")
	$Shield/Shield8.play("hide")
	$Shield/Shield9.play("hide")
	$Shield/Shield10.play("hide")
	
	var tempShield = Global.shield
	while tempShield > 0:
		match tempShield:
			1:
				$Shield/Shield1.play("deploy")
			2:
				$Shield/Shield2.play("deploy")
			3:
				$Shield/Shield3.play("deploy")
			4:
				$Shield/Shield4.play("deploy")
			5:
				$Shield/Shield5.play("deploy")
			6:
				$Shield/Shield6.play("deploy")
			7:
				$Shield/Shield7.play("deploy")
			8:
				$Shield/Shield8.play("deploy")
			9:
				$Shield/Shield9.play("deploy")
			10:
				$Shield/Shield10.play("deploy")
		tempShield -= 1
	
	if float(Global.shield) / float(Global.shieldLimit) >= 0.66:
		$Shield.modulate = Color(0,255,0,0.8)
	elif float(Global.shield) / float(Global.shieldLimit) >= 0.33:
		$Shield.modulate = Color(255,255,0,0.8)
	else:
		$Shield.modulate = Color(255,0,0,0.8)
