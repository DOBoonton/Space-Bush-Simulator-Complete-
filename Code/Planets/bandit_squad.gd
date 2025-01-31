extends Node2D

var test = false

func _ready():
	await get_tree().process_frame
	
	if is_in_group("banditOne"):
		if Global.banditsOne == 0:
			Global.banditsOne = randi_range(3,8)
			
		if Global.banditOneDefeat == false:
			for x in Global.banditsOne:
				var bandit = load("res://Scenes/Ships/bandit.tscn").instantiate()
				
				var xpos = randf_range(25,300)
				var ypos = randf_range(25,300)
				
				bandit.position = Vector2(xpos,ypos)
				add_child(bandit)
			$ZombieRelic/Area2D/CollisionShape2D.scale = Vector2(0.3,0.3)
		else:
			queue_free()
	elif is_in_group("banditTwo"):
		if Global.banditsTwo == 0:
			Global.banditsTwo = randi_range(3,8)
			
		if Global.banditTwoDefeat == false:
			for x in Global.banditsTwo:
				var bandit = load("res://Scenes/Ships/bandit.tscn").instantiate()
				
				var xpos = randf_range(25,300)
				var ypos = randf_range(25,300)
				
				bandit.position = Vector2(xpos,ypos)
				add_child(bandit)
			$ZombieRelic/Area2D/CollisionShape2D.scale = Vector2(0.3,0.3)
		else:
			queue_free()
func _process(delta):
	if $Bandit:
		$Bandit.add_to_group("CEO")
		$ZombieRelic.global_position = $Bandit.global_position
		$ZombieRelic.global_rotation = $Bandit.global_rotation
		$ZombieRelic.move_local_x(-52.5)
	elif $ZombieRelic:
		var findPlayer = $ZombieRelic/Area2D.get_overlapping_bodies()
		for player in findPlayer:
			if player.is_in_group("PlayerVehicle") && Global.relic < Global.relicLimit:
				if test == false:
					test = true
					Global.relic += 1
					player.relicAdd()
					$ZombieRelic.queue_free()
					
					if is_in_group("banditOne"):
						Global.banditOneDefeat = true
					elif is_in_group("banditTwo"):
						Global.banditTwoDefeat = true
