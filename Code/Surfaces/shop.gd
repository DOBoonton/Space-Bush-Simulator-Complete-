extends Node2D

@onready var tankHUD = $Hud/Gear/SolarCount
@onready var crudHUD = $Hud/Gear/CrudSolCount
@onready var timeHUD = $Hud/Gear/TimeCount

var fuel = false


func _ready():
	Global.biome = "hq"
	if Global.blackhole == true:
		Global.biome = "blackhole"
	if Global.playMusic == true:
		if Music.loop == false:
			$Music.LoopC(Global.biome, Global.time)
		else:
			$Music.Loop(Global.biome, Global.time)	
	$Hud.set_z_index(2)
	
	tankHUD.global_position += Vector2(1,-50)
	crudHUD.global_position += Vector2(1,34)
	$Hud/Gear/QuotaCount.global_position += Vector2(1,34)
	timeHUD.global_position += Vector2(4,34)
	$Hud/Gear/Version.global_position += Vector2(0,34)
	
	if Global.nebula == true:
		$Nebula.show()
		$Nebula/CollisionShape2D.disabled = false
	if Global.farmer == true:
		$Farmer.show()
		$Farmer/CollisionShape2D.disabled = false
	if Global.insurance == true:
		$Trump.show()
		$Trump/CollisionShape2D.disabled = false
	if Global.astronomy == true:
		$Astronomer.show()
		$Astronomer/CollisionShape2D.disabled = false
	if Global.underground == true:
		$Underground.show()
		$Underground2.show()
		$Underground/CollisionShape2D.disabled = false
		$Underground2/CollisionShape2D.disabled = false
	
	$Hud.Manage("store")
	$Hud/Gear.global_position = Vector2(1115.5,600.25)
	$Hud/Radar.hide()
	$Hud/Gear/BitsCount.global_position = Vector2(40,-35) + $Player.global_position
	$Hud.show()

func _process(delta):
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
		
	if Global.crudSol > 0:
		fuel = true
	else:
		fuel = false
	
	if fuel == true:
		$Vehicle/AnimatedSprite2D.play(str(Global.tier) + "F")
	else:
		$Vehicle/AnimatedSprite2D.play(str(Global.tier))
	
	#HUD
	$Hud.Manage("store")
	$Hud/Gear.global_position = Vector2(1115.5,600.25)
	$Hud/Radar.hide()
	$Hud/Gear/BitsCount.global_position = Vector2(40,-35) + $Player.global_position
	
	if Global.crisis == true:
		if Music.loop == false:
			$Music.LoopC(Global.biome, Global.time)
		else:
			$Music.Loop(Global.biome, Global.time)
		Global.crisis = false
	
	for x in $ShopDetect.get_overlapping_areas():
		if x.is_in_group("NPC"):
			x.look_at($Player.global_position)
	
	match Global.enterPrompt:
		"radarComplete":
			$Text.text = "BYE, HAVE A GREAT TIME!"
			$Text.show()
			$TextTimer.start()
			$GoodSpeech.play()
			Global.enterPrompt = "none"
		"undergroundComplete":
			if Global.undergroundProg == 1:
				$Text.text = "IT IS DANGEROUS TO GO ALONE! TAKE THIS"
			elif Global.undergroundProg in [2,3,4]:
				$Text.text = "YOUR CONTRIBUTION HAS BEEN NOTED"
			elif Global.undergroundProg == 5:
				$Text.text = "COME WITH US. YOU'RE TOO VALUABLE OF AN ASSET TO LOSE"
			$Text.show()
			$TextTimer.start()
			$GoodSpeech.play()
			Global.enterPrompt = "none"
			

func _on_vehicle_body_entered(body):
	if body.is_in_group("Player"):
		call_deferred("_change_scene")

func _change_scene():
	get_tree().change_scene_to_file("res://Scenes/Surfaces/space.tscn")


func _on_text_timer_timeout():
	$Text.hide()


func _on_underground_body_entered(body):
	if body.is_in_group("Player"):
		if Global.undergroundProg >= 5:
			Global.enterPrompt = "underground"
			$Text.text = "COME WITH US IF YOU WANT TO LIVE!"
			$Text.show()
			$TextTimer.start()
			$GoodSpeech.play()
		elif Global.relic > 0:
			Global.enterPrompt = "underground"
			$Text.text = "WANNA GIVE A RELIC TO THE CAUSE?"
			$Text.show()
			$TextTimer.start()
			$GoodSpeech.play()
		elif Global.undergroundProg > 0:
			$Text.text = "THERE'S NO TIME FOR SHORT TALK UNFORTUNATELY"
			$Text.show()
			$TextTimer.start()
			$Speech.play()
		else:
			$Text.text = "GATHER SOME RELICS, THEN WE'LL TALK"
			$Text.show()
			$TextTimer.start()
			$Speech.play()


func _on_nebula_body_entered(body):
	pass
#	if body.is_in_group("Player"): add once followers exist
#		var followerCap = 0
#		for x in Global.followers:
#			followerCap += 1
#		if followerCap <= 2:
#			if Global.bits >= 45:
#				Global.enterPrompt = "nebula"
#				$Text.text = "WE OFFER HIRED GUNS, ONE FOR 30β"
#				$Text.show()
#				$TextTimer.start()
#				$GoodSpeech.play()
#			else:
#				$Text.text = "WE HAVE NOTHING FOR BROKIES!"
#				$Text.show()
#				$TextTimer.start()
#				$Speech.play()


func _on_farmer_body_entered(body):
	pass
#	if body.is_in_group("Player"): add once followers exist
#		var followerCap = 0
#		for x in Global.followers:
#			followerCap += 1
#		if followerCap <= 2:
#			if Global.bits >= 20:
#				Global.enterPrompt = "farmer"
#				$Text.text = "I HELP FOR 20β"
#				$Text.show()
#				$TextTimer.start()
#				$GoodSpeech.play()
#			else:
#				$Text.text = "NO MONEY, NO WORK"
#				$Text.show()
#				$TextTimer.start()
#				$Speech.play()


func _on_trump_body_entered(body):
	if body.is_in_group("Player"):
		if Global.bits >= 40:
			Global.enterPrompt = "insurance"
			$Text.text = "I CAN MAKE YOUR SHIP GREAT AGAIN! ONLY FOR 40β TOO"
			$Text.show()
			$TextTimer.start()
			$GoodSpeech.play()
		else:
			$Text.text = "YOU'RE FIRED!... I FORGOT I DON'T OWN CosmOil"
			$Text.show()
			$TextTimer.start()
			$Speech.play()


func _on_astronomer_body_entered(body):
	if body.is_in_group("Player"):
		match Global.radar:
			0:
				if Global.bits >= 30:
					Global.enterPrompt = "radar1"
					$Text.text = "I CAN OFFER A BETTER RADAR FOR 30β"
					$Text.show()
					$TextTimer.start()
					$GoodSpeech.play()
				else:
					$Text.text = "COME BACK LATER FOR BETTER EQUIPMENT!"
					$Text.show()
					$TextTimer.start()
					$Speech.play()
			1:
				if Global.bits >= 65:
					Global.enterPrompt = "radar2"
					$Text.text = "I CAN OFFER A BETTER RADAR FOR 65β"
					$Text.show()
					$TextTimer.start()
					$GoodSpeech.play()
				else:
					$Text.text = "COME BACK LATER FOR BETTER EQUIPMENT!"
					$Text.show()
					$TextTimer.start()
					$Speech.play()
			2:
				if Global.bits >= 120:
					Global.enterPrompt = "radar3"
					$Text.text = "I CAN OFFER A BETTER RADAR FOR 120β"
					$Text.show()
					$TextTimer.start()
					$GoodSpeech.play()
				else:
					$Text.text = "COME BACK LATER FOR BETTER EQUIPMENT!"
					$Text.show()
					$TextTimer.start()
					$Speech.play()
