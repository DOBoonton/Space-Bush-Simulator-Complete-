extends Node2D

@onready var tankHUD = $Hud/Gear/SolarCount
@onready var crudHUD = $Hud/Gear/CrudSolCount
@onready var timeHUD = $Hud/Gear/TimeCount

var bodies

func _ready(): #make vendors sell stuff by hq (in the form of their ships)
	Global.biome = "space"
	if Global.blackhole == true:
		Global.biome = "blackhole"
	$Hud/Gear.play("n")
	if Global.playMusic == true:
		if Music.loop == false:
			$Music.LoopC(Global.biome, Global.time)
		else:
			$Music.Loop(Global.biome, Global.time)
	#planet randomization code
	$HQ.global_position = Global.hq
	$Mars.global_position = Global.mars
	$Shop.global_position = Global.shop
	$Goldalis.global_position = Global.goldalis
	$RangerPrime.global_position = Global.rangerprime
	$AbandonedHQ1.global_position = Global.abandonedhqOne
	$AbandonedHQ2.global_position = Global.abandonedhqTwo
	$BanditSquad1.global_position = Global.banditOne
	$BanditSquad2.global_position = Global.banditTwo
	$FederationDreadnought1.global_position = Global.federationOne
	#$Federation2.global_position = Global.federationTwo
	#$Federation3.global_position = Global.federationThree
	#$pirate1.global_position = Global.pirateOne
	#$pirate2.global_position = Global.pirateTwo
	
	if Global.harsh == "abyssari":
		$Magmus.queue_free()
		$AbyssariL.queue_free()
		$Abyssari.global_position = Global.harshS
		$MagmusL.global_position = Global.harshL
	else:
		$Abyssari.queue_free()
		$MagmusL.queue_free()
		$Magmus.global_position = Global.harshS
		$AbyssariL.global_position = Global.harshL
	
	$BlackHole.global_position = Global.blackholeP
	
	if Global.underground == true:
		$Shop/Underground.modulate += Color(0,0,0,1)
	if Global.nebula == true:
		$Shop/Nebula.modulate += Color(0,0,0,1)
	if Global.farmer == true:
		$Shop/Farmer.modulate += Color(0,0,0,1)
	if Global.insurance == true:
		$Shop/Insurance.modulate += Color(0,0,0,1)
	if Global.astronomy == true:
		$Shop/Astronomy.modulate += Color(0,0,0,1)

func _process(delta):
	if Global.underground == true:
		$Shop/Underground.modulate += Color(0,0,0,0.001)
	if Global.nebula == true:
		$Shop/Nebula.modulate += Color(0,0,0,0.001)
	if Global.farmer == true:
		$Shop/Farmer.modulate += Color(0,0,0,0.001)
	if Global.insurance == true:
		$Shop/Insurance.modulate += Color(0,0,0,0.001)
	if Global.astronomy == true:
		$Shop/Astronomy.modulate += Color(0,0,0,0.001)
	
	$BlackHole.global_scale = Vector2(Global.blackholeSize,Global.blackholeSize)
	
	bodies = $BlackHole/BlackHoleArea.get_overlapping_areas()
	for x in bodies:
		if not x.is_in_group("BlackProof"):
			x.modulate -= Color(0,5.5,5.5,0.0005)
			x.set_process(false)
			x.set_physics_process(false)
	
	bodies = $BlackHole/BlackHoleArea.get_overlapping_bodies()
	for x in bodies:
		x.modulate -= Color(0,5.5,5.5,0.0005)
		if x.is_in_group("PlayerVehicle"):
			$Hud/Gear/TimeCount.hide()
			Global.time += 1
			if $BlackHoleTime.time_left == 0:
				$BlackHoleTime.start()
		x.set_process(false)
		x.set_physics_process(false)
	
	var combat = false
	for x in $Vehicle/EnemyDetect.get_overlapping_bodies():
		if x.is_in_group("enemy"):
			combat = true
		
			if x.is_in_group("federationDreadnought"):
				if x.is_in_group("One"):
					Global.boss = "federation1"
				elif x.is_in_group("Two"):
					Global.boss = "federation2"
				elif x.is_in_group("Three"):
					Global.boss = "federation3"
		else:
			Global.boss = ""
	
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
	elif combat == true && Global.biome != "combat" && $Vehicle/WaitTime.time_left == 0:
		Global.biome = "combat"
		if Global.playMusic == true:
			Global.playMusic = false
			$Music.LoopC(Global.biome, Global.time)
			$Music.Loop(Global.biome, Global.time)	
			Global.playMusic = true
			
			if Music.loop == false:
				$Music.LoopC(Global.biome, Global.time)
			else:
				$Music.Loop(Global.biome, Global.time)
	elif combat == false && Global.biome == "combat" && $Vehicle/WaitTime.time_left == 0:
		Global.biome = "space"
		if Global.playMusic == true:
			Global.playMusic = false
			$Music.LoopC(Global.biome, Global.time)
			$Music.Loop(Global.biome, Global.time)	
			Global.playMusic = true
			
			if Music.loop == false:
				$Music.LoopC(Global.biome, Global.time)
			else:
				$Music.Loop(Global.biome, Global.time)
		
	$TileMap2.global_position = $Vehicle.global_position / 2
	
	$Hud.Manage("hq")
	$Hud/Gear.global_position = Vector2(539.5,278) + $Vehicle.position
	$Hud/Radar.global_position = $Vehicle.position
	$Hud/Gear.global_rotation_degrees = 0
	
	match Global.radarTarget:
		"mars":
			$Hud/Radar.look_at($Mars.global_position)
			$Hud/Radar.scale.x = 15000 / $Hud/Radar.global_position.distance_to($Mars.global_position)
			$Hud/Radar.scale.y = 15000 / $Hud/Radar.global_position.distance_to($Mars.global_position)
			if 15000 / $Hud/Radar.global_position.distance_to($Mars.global_position) >= 17:
				$Hud/Radar.scale.x = 0
				$Hud/Radar.scale.y = 0
		"hq":
			$Hud/Radar.look_at($HQ.global_position)
			$Hud/Radar.scale.x = 15000 / $Hud/Radar.global_position.distance_to($HQ.global_position)
			$Hud/Radar.scale.y = 15000 / $Hud/Radar.global_position.distance_to($HQ.global_position)
			if 15000 / $Hud/Radar.global_position.distance_to($HQ.global_position) >= 17:
				$Hud/Radar.scale.x = 0
				$Hud/Radar.scale.y = 0
		"shop":
			$Hud/Radar.look_at($Shop.global_position)
			$Hud/Radar.scale.x = 15000 / $Hud/Radar.global_position.distance_to($Shop.global_position)
			$Hud/Radar.scale.y = 15000 / $Hud/Radar.global_position.distance_to($Shop.global_position)
			if 15000 / $Hud/Radar.global_position.distance_to($Shop.global_position) >= 17:
				$Hud/Radar.scale.x = 0
				$Hud/Radar.scale.y = 0
		"harsh":
			if Global.harsh == "abyssari":
				$Hud/Radar.look_at($Abyssari.global_position)
				$Hud/Radar.scale.x = 15000 / $Hud/Radar.global_position.distance_to($Abyssari.global_position)
				$Hud/Radar.scale.y = 15000 / $Hud/Radar.global_position.distance_to($Abyssari.global_position)
				if 15000 / $Hud/Radar.global_position.distance_to($Abyssari.global_position) >= 17:
					$Hud/Radar.scale.x = 0
					$Hud/Radar.scale.y = 0
			else:
				$Hud/Radar.look_at($Magmus.global_position)
				$Hud/Radar.scale.x = 15000 / $Hud/Radar.global_position.distance_to($Magmus.global_position)
				$Hud/Radar.scale.y = 15000 / $Hud/Radar.global_position.distance_to($Magmus.global_position)
				if 15000 / $Hud/Radar.global_position.distance_to($Magmus.global_position) >= 17:
					$Hud/Radar.scale.x = 0
					$Hud/Radar.scale.y = 0
		"goldalis":
			$Hud/Radar.look_at($Goldalis.global_position)
			$Hud/Radar.scale.x = 15000 / $Hud/Radar.global_position.distance_to($Goldalis.global_position)
			$Hud/Radar.scale.y = 15000 / $Hud/Radar.global_position.distance_to($Goldalis.global_position)
			if 15000 / $Hud/Radar.global_position.distance_to($Goldalis.global_position) >= 17:
				$Hud/Radar.scale.x = 0
				$Hud/Radar.scale.y = 0
		"rangerprime":
			$Hud/Radar.look_at($RangerPrime.global_position)
			$Hud/Radar.scale.x = 15000 / $Hud/Radar.global_position.distance_to($RangerPrime.global_position)
			$Hud/Radar.scale.y = 15000 / $Hud/Radar.global_position.distance_to($RangerPrime.global_position)
			if 15000 / $Hud/Radar.global_position.distance_to($Goldalis.global_position) >= 17:
				$Hud/Radar.scale.x = 0
				$Hud/Radar.scale.y = 0
		"abandonedhq":
			var hqList = []
			var minDistance = 1000000
			var selected
			
			hqList = MassDetectGroup($ShipDetect.get_overlapping_areas(), "abandonedHQ")
			for hq in hqList:
				if hq == Global.abandonedhqOne && Global.relicOne == 0:
					pass
				elif hq == Global.abandonedhqTwo && Global.relicTwo == 0:
					pass
				else:
					var currentDistance = $Hud/Radar.global_position.distance_to(hq)
					if currentDistance < minDistance:
						minDistance = currentDistance
						selected = hq
				
			if selected:
				$Hud/Radar.look_at(selected)
				$Hud/Radar.scale.x = 15000 / $Hud/Radar.global_position.distance_to(selected)
				$Hud/Radar.scale.y = 15000 / $Hud/Radar.global_position.distance_to(selected)
				if 15000 / $Hud/Radar.global_position.distance_to(selected) >= 25:
					$Hud/Radar.scale.x = 0
					$Hud/Radar.scale.y = 0
			else:
				$Vehicle.target += 1
		"federation":
			var shipList = []
			var minDistance = 1000000
			var selected
			
			shipList = MassDetectGroup($ShipDetect.get_overlapping_bodies(), "federationDreadnought")
			for ship in shipList:
				var currentDistance = $Hud/Radar.global_position.distance_to(ship)
				if currentDistance < minDistance:
					minDistance = currentDistance
					selected = ship
			
			if selected:
				$Hud/Radar.look_at(selected)
				$Hud/Radar.scale.x = 15000 / $Hud/Radar.global_position.distance_to(selected)
				$Hud/Radar.scale.y = 15000 / $Hud/Radar.global_position.distance_to(selected)
				if 15000 / $Hud/Radar.global_position.distance_to(selected) >= 25:
					$Hud/Radar.scale.x = 0
					$Hud/Radar.scale.y = 0
			else:
				shipList = MassDetectGroup($ShipDetect.get_overlapping_bodies(), "federationDreadnought")
				for ship in shipList:
					var currentDistance = $Hud/Radar.global_position.distance_to(ship)
					if currentDistance < minDistance:
						minDistance = currentDistance
						selected = ship
				if selected:
					$Hud/Radar.look_at(selected)
					$Hud/Radar.scale.x = 15000 / $Hud/Radar.global_position.distance_to(selected)
					$Hud/Radar.scale.y = 15000 / $Hud/Radar.global_position.distance_to(selected)
					if 15000 / $Hud/Radar.global_position.distance_to(selected) >= 25:
						$Hud/Radar.scale.x = 0
						$Hud/Radar.scale.y = 0
				else:
					$Vehicle.target += 1
		#"pirate": detect nearest pirate ship (main one)
			#$Hud/Radar.look_at($Goldalis.global_position)
			#$Hud/Radar.scale.x = 15000 / $Hud/Radar.global_position.distance_to($Mars.global_position)
			#$Hud/Radar.scale.y = 15000 / $Hud/Radar.global_position.distance_to($Mars.global_position)
			#if 15000 / $Hud/Radar.global_position.distance_to($Mars.global_position) >= 17:
				#$Hud/Radar.scale.x = 0
				#$Hud/Radar.scale.y = 0
		"bandits":
			var shipList = []
			var minDistance = 1000000
			var selected
			
			shipList = MassDetectGroup($ShipDetect.get_overlapping_bodies(), "bandit")
			for ship in shipList:
				var currentDistance = $Hud/Radar.global_position.distance_to(ship)
				if currentDistance < minDistance:
					minDistance = currentDistance
					selected = ship
			
			if selected:
				$Hud/Radar.look_at(selected)
				$Hud/Radar.scale.x = 15000 / $Hud/Radar.global_position.distance_to(selected)
				$Hud/Radar.scale.y = 15000 / $Hud/Radar.global_position.distance_to(selected)
				if 15000 / $Hud/Radar.global_position.distance_to(selected) >= 25:
					$Hud/Radar.scale.x = 0
					$Hud/Radar.scale.y = 0
			else:
				MassDetectGroup($ShipDetect.get_overlapping_bodies(), shipList)		
				for ship in shipList:
					var currentDistance = $Hud/Radar.global_position.distance_to(ship)
					if currentDistance < minDistance:
						minDistance = currentDistance
						selected = ship
				if selected:
					$Hud/Radar.look_at(selected)
					$Hud/Radar.scale.x = 15000 / $Hud/Radar.global_position.distance_to(selected)
					$Hud/Radar.scale.y = 15000 / $Hud/Radar.global_position.distance_to(selected)
					if 15000 / $Hud/Radar.global_position.distance_to(selected) >= 25:
						$Hud/Radar.scale.x = 0
						$Hud/Radar.scale.y = 0
				else:
					$Vehicle.target += 1
		"harshl":
			if Global.harsh == "abyssari":
				$Hud/Radar.look_at($MagmusL.global_position)
				$Hud/Radar.scale.x = 15000 / $Hud/Radar.global_position.distance_to($MagmusL.global_position)
				$Hud/Radar.scale.y = 15000 / $Hud/Radar.global_position.distance_to($MagmusL.global_position)
				if 15000 / $Hud/Radar.global_position.distance_to($MagmusL.global_position) >= 17:
					$Hud/Radar.scale.x = 0
					$Hud/Radar.scale.y = 0
			else:
				$Hud/Radar.look_at($AbyssariL.global_position)
				$Hud/Radar.scale.x = 15000 / $Hud/Radar.global_position.distance_to($AbyssariL.global_position)
				$Hud/Radar.scale.y = 15000 / $Hud/Radar.global_position.distance_to($AbyssariL.global_position)
				if 15000 / $Hud/Radar.global_position.distance_to($AbyssariL.global_position) >= 17:
					$Hud/Radar.scale.x = 0
					$Hud/Radar.scale.y = 0
	if $Hud/Radar.scale.x > 3:
		$Hud/Radar.scale.x = 3
		$Hud/Radar.scale.y = 3
	$Hud/Radar.move_local_x(250)
	$Hud/Radar.global_rotation_degrees = 0
	
	if Global.crisis == true:
		if Music.loop == false:
			$Music.LoopC(Global.biome, Global.time)
		else:
			$Music.Loop(Global.biome, Global.time)
		Global.crisis = false
	
	if Global.mercy == true:
		if Global.biome != "blackhole":
			Global.biome = "blackhole"
			if Music.loop == false:
				Global.playMusic = false
				$Music.LoopC(Global.biome, Global.time)
				Global.playMusic = true
				$Music.LoopC(Global.biome, Global.time)
			else:
				Global.playMusic = false
				$Music.Loop(Global.biome, Global.time)
				Global.playMusic = true
				$Music.Loop(Global.biome, Global.time)

func _on_black_hole_time_timeout():
	Global.reset()

func MassDetectGroup(detect, group):
	if typeof(group) != TYPE_STRING:
		group = str(group)
	var list = []
	for scene in detect:
		if scene.is_in_group(group):
			list.append(scene.global_position)
	return list

func RevertMercy():
	Global.biome = "space"
	if Music.loop == false:
		Global.playMusic = false
		$Music.LoopC(Global.biome, Global.time)
		Global.playMusic = true
		$Music.LoopC(Global.biome, Global.time)
	else:
		Global.playMusic = false
		$Music.Loop(Global.biome, Global.time)
		Global.playMusic = true
		$Music.Loop(Global.biome, Global.time)
