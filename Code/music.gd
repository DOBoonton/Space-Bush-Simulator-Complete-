extends Node

var loop = false
var playing = Global.biome

func LoopC(biome, time):
	match biome:
		"space":
			$Space.play(time)
		"mars":
			$Mars.play(time)
		"hq":
			$HQ.play(time)
		"abyssari":
			$Abyssari.play(time)
		"magmus":
			$Magmus.play(time)
		"rangerprime":
			$RangerPrime.play(time)
		"goldalis":
			$Goldalis.play(time)
		"abandonedhq":
			$AbandonedHQ.play(time)
		"blackhole":
			$BlackHole.play(time)
		"truespace":
			$TrueSpace.play(time)
		"combat":
			$Combat.play(time)
	if Global.playMusic == false:
		$Space.stop()
		$SpaceLoop.stop()
		$Mars.stop()
		$MarsLoop.stop()
		$HQ.stop()
		$HQLoop.stop()
		$Abyssari.stop()
		$AbyssariLoop.stop()
		$Magmus.stop()
		$MagmusLoop.stop()
		$RangerPrime.stop()
		$RangerPrimeLoop.stop()
		$Goldalis.stop()
		$GoldalisLoop.stop()
		$AbandonedHQ.stop()
		$AbandonedHQLoop.stop()
		$BlackHole.stop()
		$BlackHoleLoop.stop()
		$TrueSpace.stop()
		$TrueSpaceLoop.stop()

func Loop(biome, time):
	match biome:
		"space":
			$SpaceLoop.play(time)
		"mars":
			$MarsLoop.play(time)
		"hq":
			$HQLoop.play(time)
		"abyssari":
			$AbyssariLoop.play(time)
		"magmus":
			$MagmusLoop.play(time)
		"rangerprime":
			$RangerPrimeLoop.play(time)
		"goldalis":
			$GoldalisLoop.play(time)
		"abandonedhq":
			$AbandonedHQLoop.play(time)
		"blackhole":
			$BlackHoleLoop.play(time)
		"truespace":
			$TrueSpaceLoop.play(time)
		"combat":
			$CombatLoop.play(time)
	if Global.playMusic == false:
		$Space.stop()
		$SpaceLoop.stop()
		$Mars.stop()
		$MarsLoop.stop()
		$HQ.stop()
		$HQLoop.stop()
		$Abyssari.stop()
		$AbyssariLoop.stop()
		$Magmus.stop()
		$MagmusLoop.stop()
		$RangerPrime.stop()
		$RangerPrimeLoop.stop()
		$Goldalis.stop()
		$GoldalisLoop.stop()
		$AbandonedHQ.stop()
		$AbandonedHQLoop.stop()
		$BlackHole.stop()
		$BlackHoleLoop.stop()
		$TrueSpace.stop()
		$TrueSpaceLoop.stop()
		$Combat.stop()
		$CombatLoop.stop()

func _on_short_timer_timeout():
	Global.time += 0.1
	if Global.time >= 84:
		Global.time = 0
		if loop == false:
			Loop(Global.biome, Global.time)
			loop = true
		elif loop == true:
			LoopC(Global.biome, Global.time)
			loop = false


func _on_clock_timeout():
	Global.minute += 1
	if Global.minute == 60:
		Global.hour += 1
		Global.minute -= 60
	if Global.hour == 24:
		match Global.day:
			"Sun":
				Global.day = "Mon"
				
				if Global.quota > 0:
					Global.fired = true
				if Global.week == 2:
					Global.quota = 20
				
				Global.nebula = false
				Global.farmer = false
				Global.insurance = false
				Global.astronomy = false
				Global.underground = false
			"Mon":
				Global.day = "Tues"
				
				if Global.hasSold == true:
					Global.sellState -= 1
				else:
					Global.sellState += 1
				
				var i = 2
				while i > 0:
					match randi_range(1,4):
						1:
							if Global.nebula == false:
								Global.nebula = true
								Global.beenJob.append("nebula" + str(Global.nebula))
								i -= 1
						2:
							if Global.farmer == false:
								Global.farmer = true
								i -= 1
								Global.beenJob.append("farmer" + str(Global.farmer))
						3:
							if Global.insurance == false:
								Global.insurance = true
								i -= 1
								Global.beenJob.append("insurance" + str(Global.insurance))
						4:
							if Global.astronomy == false:
								Global.astronomy = true
								i -= 1
								Global.beenJob.append("astronomy" + str(Global.astronomy))
				print(Global.beenJob)
					
			"Tues":
				Global.day = "Wed"
				
				if Global.hasSold == true:
					Global.sellState -= 1
				else:
					Global.sellState += 1
				
				Global.nebula = false
				Global.farmer = false
				Global.insurance = false
				Global.astronomy = false
				Global.underground = true
			"Wed":
				Global.day = "Thur"
				Global.sellState = 0
				
				if Global.quota > 0:
					Global.fired = true
				if Global.week == 1:
					Global.quota = 10
				else:
					Global.quota = 25
				
				if "nebulatrue" not in Global.beenJob:
					Global.nebula = true
				if "farmertrue" not in Global.beenJob:
					Global.farmer = true
				if "insurancetrue" not in Global.beenJob:
					Global.insurance = true
				if "astronomytrue" not in Global.beenJob:
					Global.astronomy = true
				Global.underground = false
				Global.beenJob = []
			"Thur":
				Global.day = "Fri"
				
				if Global.hasSold == true:
					Global.sellState -= 1
				else:
					Global.sellState += 1
				
				Global.nebula = false
				Global.farmer = false
				Global.insurance = false
				Global.astronomy = false
			"Fri":
				Global.day = "Sat"
				
				if Global.hasSold == true:
					Global.sellState -= 1
				else:
					Global.sellState += 1
			
				if Global.week == 2:
					Global.nebula = true
					Global.farmer = true
					Global.insurance = true
					Global.astronomy = true
					Global.underground = true
			"Sat":
				Global.day = "Sun"
				Global.sellState = 0
				
				if Global.week == 1:
					Global.nebula = true
					Global.farmer = true
					Global.insurance = true
					Global.astronomy = true
					Global.underground = true
				
				Global.week += 1
		Global.hour -= 24
		Global.hasSold = false
	
	if Global.week == 3:
		Global.blackhole = true
	
	if Global.blackhole == true:
		Global.blackholeSize += 0.025 * Global.blackholeRate
		Global.blackholeRate += 0.1
