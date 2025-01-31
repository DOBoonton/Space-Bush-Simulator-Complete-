extends Control

var timerRestart = []
var timerWait = []
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.radarTarget != "harsh" && Global.radarTarget != "harshl":
		$Radar.play(Global.radarTarget)
	elif Global.harsh == "abyssari":
		if Global.radarTarget == "harsh":
			$Radar.play("abyssari")
		else:
			$Radar.play("magmusl")
	elif Global.harsh == "magmus":
		if Global.radarTarget == "harsh":
			$Radar.play("magmus")
		else:
			$Radar.play("abyssaril")
	
	if Input.is_action_just_pressed("keyEsc"):
		var scene = self.get_parent()
		if Global.pause == false:
			Global.pause = true
			
			for x in scene.get_children():
				if x.is_in_group("music"):
					if Global.playMusic == true:
						Global.playMusic = false
						x.LoopC(Global.biome, Global.time)
						x.Loop(Global.biome, Global.time)
						Global.playMusic = true
				
				if x.get_class() == "Timer":
					if x.time_left > 0:
						timerRestart.append(x.time_left)
						timerWait.append(x.wait_time)
					else:
						timerRestart.append("")
					x.stop()
				for y in x.get_children():
					if y.get_class() == "Timer":
						if y.time_left > 0:
							timerRestart.append(y.time_left)
							timerWait.append(y.wait_time)
						else:
							timerRestart.append("")
						y.stop()
					for z in y.get_children():
						if z.get_class() == "Timer":
							if z.time_left > 0:
								timerRestart.append(z.time_left)
								timerWait.append(z.wait_time)
							else:
								timerRestart.append("")
							z.stop()
				
				if x != self:
					x.set_physics_process(false)
					x.set_process(false)
			
			scene.set_physics_process(false)
			scene.set_process(false)
			
			$Gear/Pause.show()
			$Gear/Paused.show()
		else:
			Global.pause = false
			for x in scene.get_children():
				if x.is_in_group("music"):
					if Global.playMusic != false:
						if Music.loop == false:
							x.LoopC(Global.biome, Global.time)
						else:
							x.Loop(Global.biome, Global.time)
				
				if len(timerRestart) > 0: #nothing in array for some reason in space
					if x.get_class() == "Timer":
						if typeof(timerRestart[0]) != TYPE_STRING: #error here when pausing in Space
							x.start(timerRestart[0])
							x.wait_time = timerWait[0]
							timerWait.remove_at(0)
						timerRestart.remove_at(0)
					for y in x.get_children():
						if y.get_class() == "Timer":
							if typeof(timerRestart[0]) != TYPE_STRING:
								y.start(timerRestart[0])
								y.wait_time = timerWait[0]
								timerWait.remove_at(0)
							timerRestart.remove_at(0)
						for z in y.get_children():
							if z.get_class() == "Timer":
								if typeof(timerRestart[0]) != TYPE_STRING:
									z.start(timerRestart[0])
									z.wait_time = timerWait[0]
									timerWait.remove_at(0)
								timerRestart.remove_at(0)
				
				if x != self:
					x.set_physics_process(true)
					x.set_process(true)
			
			timerRestart = []
			timerWait = []
			scene.set_physics_process(true)
			scene.set_process(true)
			$Gear/Pause.hide()
			$Gear/Paused.hide()
			$Gear/Mute.hide()
			$Gear/Debug.hide()
	
	if Global.pause == true:
		if Input.is_action_just_pressed("keyM"):
			if Global.playMusic == true:
				Global.playMusic = false
			else:
				Global.playMusic = true
		
		if Input.is_action_just_pressed("keyQ"):
			if Global.debug == false:
				Global.debug = true
			else:
				Global.debug = false
		
		if Global.playMusic == false:
			$Gear/Mute.show()
		else:
			$Gear/Mute.hide()
		if Global.debug == true:
			$Gear/Debug.show()
		else:
			$Gear/Debug.hide()

func Manage(location):
	var after = ""
	var solarHUD = (Global.currentSolar - (Global.currentSolar % 10000)) / 10000
	solarHUD = Global.RoundSpec(float(solarHUD) + (float(Global.currentSolar % 10000) / 10000),6)
	match Global.maxSolar:
		3000:
			after = "0.3000"
		12500:
			after = "1.2500"
		42500:
			after = "4.2500"
		187500:
			after = "18.750"
		87500:
			after = "8.7500"
		2500000:
			after = "250.00"
	match len(str(solarHUD)):
		1:
			$Gear/SolarCount.text = "AU: " + str(solarHUD) + ".0000/" + after
		2:
			$Gear/SolarCount.text = "AU: " + str(solarHUD) + ".000/" + after
		3:
			if "." in str(solarHUD):
				$Gear/SolarCount.text = "AU: " + str(solarHUD) + "000/" + after
			else:
				$Gear/SolarCount.text = "AU: " + str(solarHUD) + ".00/" + after
		4:
			if "." in str(solarHUD):
				$Gear/SolarCount.text = "AU: " + str(solarHUD) + "00/" + after
			else:
				$Gear/SolarCount.text = "AU: " + str(solarHUD) + ".0/" + after
		5:
			if "." in str(solarHUD):
				$Gear/SolarCount.text = "AU: " + str(solarHUD) + "0/" + after
			else:
				$Gear/SolarCount.text = "AU: " + str(solarHUD) + "/" + after
		_:
			$Gear/SolarCount.text = "AU: " + str(solarHUD) + "/" + after
	
	var solHUD = (Global.crudSol - (Global.crudSol % 100)) / 100
	solHUD = Global.RoundSpec(float(solHUD) + (float(Global.crudSol % 100) / 100),3)
	match Global.maxCrudSol:
		300:
			after = "3.00"
		800:
			after = "8.00"
		3000:
			after = "30.00"
		15000:
			after = "150.0"
		1500:
			after = "15.00"
		4500:
			after = "45.00"
		
	match len(str(solHUD)):
		1:
			$Gear/CrudSolCount.text = "CRUD: " + str(solHUD) + ".00/" + after
		2:
			$Gear/CrudSolCount.text = "CRUD: " + str(solHUD) + ".0/" + after
		3:
			if "." in str(solHUD):
				$Gear/CrudSolCount.text = "CRUD: " + str(solHUD) + "0/" + after
			else:
				$Gear/CrudSolCount.text = "CRUD: " + str(solHUD) + "/" + after
		_:
			$Gear/CrudSolCount.text = "CRUD: " + str(solHUD) + "/" + after
	
	if Global.minute < 10 && Global.hour < 10:
		$Gear/TimeCount.text = Global.day + " | 0" + str(Global.hour) + ":0" + str(Global.minute)
	elif Global.minute < 10:
		$Gear/TimeCount.text = Global.day + " | " + str(Global.hour) + ":0" + str(Global.minute)
	elif Global.hour < 10:
		$Gear/TimeCount.text = Global.day + " | 0" + str(Global.hour) + ":" + str(Global.minute)
	else:
		$Gear/TimeCount.text = Global.day + " | " + str(Global.hour) + ":" + str(Global.minute)
	match Global.week:
		1:
			if Global.day in ["Mon","Tues","Wed"]:
				$Gear/QuotaCount.text = "QUOTA: " + str(Global.quota) + "/" + "5"
			elif Global.day in ["Thur","Fri","Sat"]:
				$Gear/QuotaCount.text = "QUOTA: " + str(Global.quota) + "/" + "10"
		2:
			if Global.day in ["Mon","Tues","Wed"]:
				$Gear/QuotaCount.text = "QUOTA: " + str(Global.quota) + "/" + "20"
			elif Global.day in ["Thur","Fri","Sat"]:
				$Gear/QuotaCount.text = "QUOTA: " + str(Global.quota) + "/" + "25"
	if Global.quota == 0 || Global.fired == true || Global.blackhole == true:
		$Gear/QuotaCount.hide()
	else:
		$Gear/QuotaCount.show()
	$Gear/BitsCount.text = str(Global.bits) + "β"
	$Gear.play("n")
	
	match location:
		"planet":
			$Gear/SolarCount.hide()
	
	match Global.boss:
		"federation1":
			$Gear/BossHP.show()
			$Gear/BossHP.value = Global.federationOneHP
		"federation2":
			$Gear/BossHP.show()
			$Gear/BossHP.value = Global.federationTweHP
		"federation3":
			$Gear/BossHP.show()
			$Gear/BossHP.value = Global.federationThreeHP
		_:
			$Gear/BossHP.hide()
	if self.get_parent().is_in_group("PlayerVehicle"):
		$Gear/ShieldRecharge.show()
	else:
		$Gear/ShieldRecharge.hide()
