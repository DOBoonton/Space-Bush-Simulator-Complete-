extends Node2D

@onready var spawn = $ZombieSpawn
@onready var spawnCD = $ZombieTimer
@onready var tankHUD = $Hud/Gear/SolarCount
@onready var crudHUD = $Hud/Gear/CrudSolCount
@onready var timeHUD = $Hud/Gear/TimeCount

var spawnCount = 1
var bushes = 0
var fuel = false
var timeLeft


func _ready():
	Global.biome = "abyssari"
	if Global.blackhole == true:
		Global.biome = "blackhole"
	get_tree().call_group("zombieAbyssariLarge", "queue_free")
	spawnCD.start()
	if Global.playMusic == true:
		if Music.loop == false:
			$Music.LoopC(Global.biome, Global.time)
		else:
			$Music.Loop(Global.biome, Global.time)
	$Hud.set_z_index(2)
	$Night.set_z_index(1)


func _process(delta):
	if Global.pause == true:
		timeLeft = spawnCD.time_left
		spawnCD.stop()
	else:
		if timeLeft:
			spawnCD.start(timeLeft)
			timeLeft = null
	
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
	
	$Hud.Manage("planet")
	$Hud/Gear.global_position = Vector2(1115.5,600.25)
	$Hud/Radar.hide()
	$Night.color = Color(0,0,0,0.05 * cos((3.14159 / 720) * (Global.minute + (Global.hour * 60))) + 0.65)
	
	if Global.crisis == true:
		if Music.loop == false:
			$Music.LoopC(Global.biome, Global.time)
		else:
			$Music.Loop(Global.biome, Global.time)
		Global.crisis = false


func _on_zombie_timer_timeout():
	for x in spawnCount:
		if bushes <= 254:
			var zombie = load("res://Scenes/Bushes/zombieAbyssariLarge.tscn").instantiate()
			
			var decision = randi_range(0,4)
			var xpos
			var ypos
			if decision == 1:
				xpos = randf_range(0,16)*16
				ypos = randf_range(0,16)*16
			elif decision == 2:
				xpos = randf_range(36,46)*16
				ypos = randf_range(0,40)*16
			elif decision == 3:
				xpos = randf_range(62,72)*16
				ypos = randf_range(0,20)*16
			else:
				xpos = randf_range(66,72)*16
				ypos = randf_range(0,34)*16
			zombie.position = Vector2(xpos,ypos)
			add_child(zombie)


func _on_vehicle_body_entered(body):
	if body.is_in_group("Player"):
		call_deferred("_change_scene")

func _change_scene():
	get_tree().change_scene_to_file("res://Scenes/Surfaces/space.tscn")
