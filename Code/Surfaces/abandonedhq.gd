extends Node2D

@onready var tankHUD = $Hud/Gear/SolarCount
@onready var crudHUD = $Hud/Gear/CrudSolCount
@onready var timeHUD = $Hud/Gear/TimeCount

var fuel = false
var first = true

func _ready():
	Global.biome = "abandonedhq"
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
	
	var i = Global.relicOne
	while i > 0:
		var relic = load("res://Scenes/Bushes/zombieRelic.tscn").instantiate()
		
		var xpos = randf_range(0,72)*16
		var ypos = randf_range(20,40)*16
		
		relic.position = Vector2(xpos,ypos)
		add_child(relic)
		i -= 1

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
	$Hud.Manage("planet")
	$Hud/Gear.global_position = Vector2(1115.5,600.25)
	$Hud/Radar.hide()
	$Hud/Gear/BitsCount.global_position = Vector2(40,-35) + $Player.global_position
	
	if Global.crisis == true:
		if Music.loop == false:
			$Music.LoopC(Global.biome, Global.time)
		else:
			$Music.Loop(Global.biome, Global.time)
		Global.crisis = false
	
	if $ZombieRelic:
		var findPlayer = $ZombieRelic/Area2D.get_overlapping_bodies()
		for player in findPlayer:
			if player.is_in_group("Player") && Global.relic < Global.relicLimit:
				Global.relic += 1
				player.relicAdd()
				Global.relicOne -= 1
				$ZombieRelic.queue_free()

func _on_vehicle_body_entered(body):
	if body.is_in_group("Player"):
		call_deferred("_change_scene")

func _change_scene():
	get_tree().change_scene_to_file("res://Scenes/Surfaces/space.tscn")
