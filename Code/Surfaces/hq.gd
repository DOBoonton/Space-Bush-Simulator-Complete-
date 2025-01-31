extends Node2D

@onready var tankHUD = $Hud/Gear/SolarCount
@onready var crudHUD = $Hud/Gear/CrudSolCount
@onready var timeHUD = $Hud/Gear/TimeCount

var fuel = false
var refuelTimes = 0
var refuelCheck = true
var hasPlayer
var i = 0
var artemisRepair = false

func _ready():
	Global.radarTarget = "mars"
	Global.biome = "hq"
	if Global.blackhole == true:
		Global.biome = "blackhole"
	if ((Global.day == "Fri" && Global.hour >= 22) || Global.day == "Sat") && Global.week == 2:
		Global.biome = "abandonedhq"
	if Global.playMusic == true:
		if Music.loop == false:
			$Music.LoopC(Global.biome, Global.time)
		else:
			$Music.Loop(Global.biome, Global.time)
	if Global.blackhole != true || not (((Global.day == "Fri" && Global.hour >= 22) || Global.day == "Sat")  && Global.week == 2):
		tankHUD.global_position += Vector2(94,-448)
		crudHUD.global_position += Vector2(1,392)
		$Hud/Gear/QuotaCount.global_position += Vector2(1,392)
		timeHUD.global_position += Vector2(4,34)
		$Hud/Gear/Version.global_position += Vector2(0,34)
	$Text.hide()
	
	if (Global.week == 2 && ((Global.day == "Fri" && Global.hour >= 22) || Global.day == "Sat")) || Global.blackhole == true:
		$GeorgeBush.global_position = Vector2 (1500,1500)
		$GeorgeBushUpgrade/CollisionShape2D.global_position = Vector2 (1200,1200)
		$Counter.global_position = Vector2 (1800,1800)
	
	$Hud.Manage("hq")
	$Hud/Gear.global_position = Vector2(1115.5,600.25)
	$Hud/Radar.hide()
	$Hud/Gear/BitsCount.global_position = Vector2(40,-35) + $Player.global_position
	$Hud.show()
	
	#Global.week = 2
	#Global.day = "Sat"
	#Global.hour = 23
	#Global.minute = 30
	#Global.relic = 5
	#Global.relicLimit = 10
	#Armageddon

func _process(delta):
	if Global.robot == true:
		$GeorgeBush/George.region_rect = Rect2(28, 0, 27, 64)
	
	if Global.blackhole == true && Global.biome != "blackhole":
		Global.biome = "blackhole"
		if Global.playMusic == true:
			Global.playMusic = false
			$Music.LoopC(Global.biome, Global.time)
			$Music.Loop(Global.biome, Global.time)	
			Global.playMusic = true
			
			if Music.loop == false:
				$Music.LoopC(Global.biome, Global.time)
			else:
				$Music.Loop(Global.biome, Global.time)
	
	match Global.tier:
			1:
				Global.maxSolar = 3000
				Global.maxCrudSol = 300
				Global.relicLimit = 1
				Global.shieldLimit = 2
				Global.shieldRecharge = 0.25
				$GeorgeBushUpgrade/Sprite2D.region_rect = Rect2(0,0,64,64)
			2:
				Global.maxSolar = 12500
				Global.maxCrudSol = 800
				Global.relicLimit = 1
				Global.shieldLimit = 3
				Global.shieldRecharge = 0.25
				$GeorgeBushUpgrade/Sprite2D.region_rect = Rect2(65,0,64,64)
			3:
				Global.maxSolar = 42500
				Global.maxCrudSol = 3000
				Global.relicLimit = 1
				Global.shieldLimit = 5
				Global.shieldRecharge = 0.1875
				$GeorgeBushUpgrade/Sprite2D.region_rect = Rect2(130,0,64,64)
			4:
				Global.maxSolar = 187500
				Global.maxCrudSol = 15000
				Global.relicLimit = 1
				Global.shieldLimit = 10
				Global.shieldRecharge = 0.0625
				$GeorgeBushUpgrade/Sprite2D.region_rect = Rect2(130,0,64,64)
			5:
				Global.maxSolar = 87500
				Global.maxCrudSol = 1500
				Global.relicLimit = 2
				Global.shieldLimit = 6
				Global.shieldRecharge = 0.125
				$GeorgeBushUpgrade/Sprite2D.region_rect = Rect2(130,0,64,64)
			6:
				Global.maxSolar = 2500000
				Global.maxCrudSol = 4500
				Global.relicLimit = 1
				Global.shieldLimit = 5
				Global.shieldRecharge = 0.125
				$GeorgeBushUpgrade/Sprite2D.region_rect = Rect2(130,0,64,64)
	
	if Global.crudSol > 0:
		fuel = true
	else:
		fuel = false
	
	if fuel == true:
		$Vehicle/AnimatedSprite2D.play(str(Global.tier) + "F")
	else:
		$Vehicle/AnimatedSprite2D.play(str(Global.tier))
	
	$Hud.Manage("hq")
	$Hud/Gear.global_position = Vector2(1115.5,600.25)
	$Hud/Radar.hide()
	$Hud/Gear/BitsCount.global_position = Vector2(40,-35) + $Player.global_position 
	
	if Global.crisis == true:
		if Music.loop == false:
			$Music.LoopC(Global.biome, Global.time)
		else:
			$Music.Loop(Global.biome, Global.time)
		Global.crisis = false
	
	$GeorgeBush/George.look_at($Player.global_position)
	
	if Global.enterPrompt == "shipComplete":
		match Global.tier:
			2:
				$Text.text = "BOUGHT BASIC SHIP FOR 100β"
				$Text.show()
				$TextTimer.start()
			3:
				$Text.text = "BOUGHT TRANSPORT SHIP FOR 225β"
				$Text.show()
				$TextTimer.start()
			4:
				$Text.text = "BOUGHT INTERSTELLAR CosmOil TRANSPORTER FOR 450β"
				$Text.show()
				$TextTimer.start()
		Global.enterPrompt = "empty"
		match Global.tier:
			1:
				Global.maxSolar = 3000
				Global.shieldLimit = 2
				Global.shield = Global.shieldLimit
				Global.shieldRecharge = 1
			2:
				Global.maxSolar = 12500
				Global.shieldLimit = 3
				Global.shield = Global.shieldLimit  / 2
				Global.shieldRecharge = 1
			3:
				Global.maxSolar = 42500
				Global.shieldLimit = 5
				Global.shield = Global.shieldLimit  / 2
				Global.shieldRecharge = 0.75
			4:
				Global.maxSolar = 187500
				Global.shieldLimit = 10
				Global.shield = Global.shieldLimit / 2
				Global.shieldRecharge = 0.25
			5:
				Global.maxSolar = 87500
				Global.shieldLimit = 6
				Global.shield = Global.shieldLimit / 2
				Global.shieldRecharge = 0.5
			6:
				Global.maxSolar = 250000
				Global.shieldLimit = 5
				Global.shield = Global.shieldLimit / 2
				Global.shieldRecharge = 0.5
		Global.currentSolar += Global.maxSolar / 2
		if Global.currentSolar > Global.maxSolar:
			Global.currentSolar = Global.maxSolar
	
	elif Global.enterPrompt == "repair":
		match Global.tier:
			1:
				Global.bits -= 50
			2:
				Global.bits -= 75
			3:
				Global.bits -= 125
			4:
				Global.bits -= 250
			5:
				Global.bits -= 150
		Global.shield = Global.shieldLimit
		Global.damaged = false
				
	elif Global.enterPrompt == "RelicEasterEggComplete":
		$Text.text = "INTERESTING... I'LL TAKE THOSE"
		$Text.show()
		$TextTimer.start()
		$Speech.play()
		Global.robot = true
		Global.enterPrompt = "empty"
	
	if Global.fired == true && not ((Global.week == 2 && ((Global.day == "Fri" && Global.hour >= 22) || Global.day == "Sat")) || Global.blackhole == true):
		Global.movement = false
		
		$Hud.hide()
		$Counter.hide()
		$Text.global_position = $GeorgeBush/George.global_position + Vector2(25,-25)
		$Player.look_at($GeorgeBush/George.global_position)
		
		if i == 0:
			Global.playMusic = false
			Global.time = 84
		
		if i <= 400:
			$GeorgeBush/George.global_position.x += 1.1
			$GeorgeBush/George.global_position.y -= 0.59625
			if i == 228:
				$Text.text = "YOU DISSAPOINT ME CADET..."
				$Text.show()
				$TextTimer.start()
				$Speech.play()
			i += 1
			$Player/LaserSprite.hide()
		elif i == 704:
			$Text.text = "YOU'RE FIRED!"
			$Text.show()
			$TextTimer.start()
			$Speech.play()
			i += 1
		elif i <= 802:
			i += 1
		elif i <= 999:
			$Player.hide()
			$GeorgeBush/George/EyeRight.show()
			$GeorgeBush/George/EyeLeft.show()
			$Fire.global_position = $Player.global_position
			$Fire.show()
			if i == 803:
				$Burn.play()
			elif i == 853:
				$Burn.play()
			elif i == 903:
				$Burn.play()
			elif i == 953:
				$Burn.play()
			i += 1
		elif i == 1000:
			$Fire.hide()
			$GeorgeBush/George/EyeRight.hide()
			$GeorgeBush/George/EyeLeft.hide()
			i += 1
		elif i < 1420:
			i += 1
		else:
			Global.reset()
		
	if Global.week == 2 && Global.day == "Fri" && (Global.hour >= 22 && Global.hour <= 23):
		$GeorgeBush.global_position += Vector2(0,0.5)
		$GeorgeBush/George.global_rotation_degrees = 90
		$GeorgeBushUpgrade/CollisionShape2D.global_position = Vector2 (1200,1200)
		crudHUD.hide()
		$Hud/Gear/QuotaCount.hide()
		if Global.biome != "abandonedhq":
			Global.biome = "abandonedhq"
			if Global.playMusic == true:
				Global.playMusic = false
				$Music.LoopC(Global.biome, Global.time)
				$Music.Loop(Global.biome, Global.time)	
				Global.playMusic = true
				
				if Music.loop == false:
					$Music.LoopC(Global.biome, Global.time)
				else:
					$Music.Loop(Global.biome, Global.time)
	elif ((Global.day == "Fri" && Global.hour >= 22) || Global.day == "Sat") && Global.week == 2:
		crudHUD.hide()
		$Hud/Gear/QuotaCount.hide()



func _on_vehicle_body_entered(body):
	if body.is_in_group("Player"):
		call_deferred("_change_scene")

func _change_scene():
	get_tree().change_scene_to_file("res://Scenes/Surfaces/space.tscn")

func _on_george_bush_body_entered(body):
	if body.is_in_group("Player") && Global.crudSol >= 1:
		var bitFactor = 45
		Global.hasSold = true
		
		if Global.week == 1:
			match Global.sellState:
				1:
					bitFactor = 45
				2:
					bitFactor = 48
				3:
					bitFactor = 75
				-1:
					bitFactor = 44
				-2:
					bitFactor = 39
				-3:
					bitFactor = 29
		else:
			match Global.sellState:
				0:
					bitFactor = 48
				1:
					bitFactor = 48
				2:
					bitFactor = 54
				3:
					bitFactor = 101
				-1:
					bitFactor = 44
				-2:
					bitFactor = 33
				-3:
					bitFactor = 8
		
		Global.bits += (Global.crudSol / 100) * bitFactor
		Global.quota -= Global.crudSol / 100
		if Global.quota < 0:
			Global.quota = 0
		if Global.crudSol > 100:
			$Text.text = "SOLD " + str(Global.crudSol / 100) + " CRUDE SOLAR FOR " + str((Global.crudSol / 100) * bitFactor) + "β"
			$Text.show()
			$TextTimer.start()
		if Global.crudSol % 100 > 0:
			Global.crudSol -= (Global.crudSol / 100) * 100
		else:
			Global.crudSol = 0
			
		if Global.relic > 0:
			Global.enterPrompt = "RelicEasterEgg"
			$Speech.play()
			
	elif body.is_in_group("Player"):
		$Text.text = "GO FETCH ME SOME CrudSol, OR YOUR'RE FIRED!"
		$Text.show()
		$TextTimer.start()
		$Speech.play()
		if Global.relic > 0:
			Global.enterPrompt = "RelicEasterEgg"


func _on_text_timer_timeout():
	$Text.hide()

func _on_gas_pump_body_entered(body):
	$GasTime.wait_time = 0.4 - refuelTimes * 0.03
	if $GasTime.wait_time <= 0.05:
		$GasTime.wait_time = 0.06
	if body.is_in_group("Player") == true && Global.maxSolar - Global.currentSolar > 0 && $GasTime.time_left == 0 && Global.bits >= 3 && refuelCheck == true:
		hasPlayer = true
		$GasTime.start()
		Global.currentSolar += 500
		Global.bits -= 3
		if Global.currentSolar > Global.maxSolar:
			Global.currentSolar = Global.maxSolar
		$Refuel.play()
		$GasPump/CollisionShape2D.global_position += Vector2(-999, -999)
		refuelTimes += 1
		refuelCheck = false
	elif refuelCheck == true && hasPlayer == false:
		refuelTimes = 0
		$GasTime.wait_time = 0.4
	else:
		return


func _on_gas_time_timeout():
	$GasPump/CollisionShape2D.global_position += Vector2(999, 999)
	refuelCheck = true
	hasPlayer == false


func _on_george_bush_upgrade_body_entered(body):
	if body.is_in_group("Player"):
		if Global.damaged == false || artemisRepair == true || Global.tier != 4:
			match Global.tier: #maybe increase the cost by x * 25 per unrepaired shield
				1:
					if Global.bits >= 100:
						Global.enterPrompt = "ship"
						$Text.text = "BUY BASIC SHIP FOR 100β?"
						$Text.show()
						$TextTimer.start()
						$SpeechGood.play()
					else:
						$Text.text = "COME BACK WHEN YOU'RE A LITTLE... RICHER"
						$Text.show()
						$TextTimer.start()
						$Speech.play()
				2:
					if Global.bits >= 225:
						Global.enterPrompt = "ship"
						$Text.text = "BUY TRANSPORT SHIP FOR 225β?"
						$Text.show()
						$TextTimer.start()
						$SpeechGood.play()
					else:
						$Text.text = "COME BACK WHEN YOU'RE A LITTLE... RICHER"
						$Text.show()
						$TextTimer.start()
						$Speech.play()
				3:
					if Global.bits >= 450:
						Global.enterPrompt = "ship"
						$Text.text = "BUY INTERSTELLAR CosmOil TRANSPORTER FOR 450β?"
						$Text.show()
						$TextTimer.start()
						$SpeechGood.play()
					else:
						$Text.text = "COME BACK WHEN YOU'RE A LITTLE... RICHER"
						$Text.show()
						$TextTimer.start()
						$Speech.play()
				5:
					if Global.bits >= 450:
						Global.enterPrompt = "ship"
						$Text.text = "BUY INTERSTELLAR CosmOil TRANSPORTER FOR 450β?"
						$Text.show()
						$TextTimer.start()
						$SpeechGood.play()
					else:
						$Text.text = "COME BACK WHEN YOU'RE A LITTLE... RICHER"
						$Text.show()
						$TextTimer.start()
						$Speech.play()
				6:
					if Global.bits >= 450:
						Global.enterPrompt = "ship"
						$Text.text = "BUY INTERSTELLAR CosmOil TRANSPORTER FOR 450β?"
						$Text.show()
						$TextTimer.start()
						$SpeechGood.play()
					else:
						$Text.text = "COME BACK WHEN YOU'RE A LITTLE... RICHER"
						$Text.show()
						$TextTimer.start()
						$Speech.play()
		else:
			match Global.tier:
				1:
					if Global.insured > 0:
						Global.enterPrompt = "repair"
						$Text.text = "REPAIR BEATER SHIP (INSURED)?"
						$Text.show()
						$TextTimer.start()
						$SpeechGood.play()
					elif Global.bits >= 50:
						$Text.text = "REPAIR BEATER SHIP FOR 50β?"
						$Text.show()
						$TextTimer.start()
						$SpeechGood.play()
					else:
						$Text.text = "REPAIR YOUR SHIP BEFORE YOU SELL IT!"
						$Text.show()
						$TextTimer.start()
						$Speech.play()
				2:
					if Global.insured > 0:
						Global.enterPrompt = "repair"
						$Text.text = "REPAIR BASIC SHIP (INSURED)?"
						$Text.show()
						$TextTimer.start()
						$SpeechGood.play()
					elif Global.bits >= 75:
						$Text.text = "REPAIR BASIC SHIP FOR 75β?"
						$Text.show()
						$TextTimer.start()
						$SpeechGood.play()
					else:
						$Text.text = "REPAIR YOUR SHIP BEFORE YOU SELL IT!"
						$Text.show()
						$TextTimer.start()
						$Speech.play()
				3:
					if Global.insured > 0:
						Global.enterPrompt = "repair"
						$Text.text = "REPAIR TRANSPORT SHIP (INSURED)?"
						$Text.show()
						$TextTimer.start()
						$SpeechGood.play()
					elif Global.bits >= 125:
						$Text.text = "REPAIR TRANSPORT SHIP FOR 125β?"
						$Text.show()
						$TextTimer.start()
						$SpeechGood.play()
					else:
						$Text.text = "REPAIR YOUR SHIP BEFORE YOU SELL IT!"
						$Text.show()
						$TextTimer.start()
						$Speech.play()
				4:
					if Global.insured > 0:
						Global.enterPrompt = "repair"
						$Text.text = "REPAIR I.C.O.T. (INSURED)?"
						$Text.show()
						$TextTimer.start()
						$SpeechGood.play()
					elif Global.bits >= 250:
						$Text.text = "REPAIR I.C.O.T. FOR 250β?"
						$Text.show()
						$TextTimer.start()
						$SpeechGood.play()
					else:
						$Text.text = "REPAIR YOUR SHIP BEFORE YOU SELL IT!"
						$Text.show()
						$TextTimer.start()
						$Speech.play()
				5:
					if Global.insured > 0:
						Global.enterPrompt = "repair"
						$Text.text = "REPAIR BLACK HAWK (INSURED)?"
						$Text.show()
						$TextTimer.start()
						$SpeechGood.play()
					elif Global.bits >= 150:
						$Text.text = "REPAIR BLACK HAWK FOR 250β?"
						$Text.show()
						$TextTimer.start()
						$SpeechGood.play()
					else:
						$Text.text = "REPAIR YOUR SHIP BEFORE YOU SELL IT!"
						$Text.show()
						$TextTimer.start()
						$Speech.play()
				6:
					$Text.text = "I CAN'T REPAIR THIS"
					$Text.show()
					$TextTimer.start()
					$Speech.play()
					artemisRepair == true


func _on_george_bush_upgrade_body_exited(body):
	if body.is_in_group("Player"):
		Global.enterPrompt = "empty"


func _on_george_bush_body_exited(body):
	if body.is_in_group("Player"):
		Global.enterPrompt = "empty"
