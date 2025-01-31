extends CharacterBody2D
#give tail shoop da whoop; attacks should be based on hp
#200 - one missile, a segment spawns ships
#150 - three missiles, b segment spawns ships
#100 - shoop da whoop, charge attack (charges up every 5 seconds, then does 1 damage every 2 seconds when in contact for 5 seconds)
#25 - constant shoop da whoop

var direction
var segment = 14
var speedPos = 0.45
var rotateRate = 0.85
var speedRot = 0.85
var dist = -35
var angle
var speed = 1

func _ready():
	await get_tree().process_frame
	$DirectionTime.start()
	direction = global_position + Vector2(randf_range(-1000,1000),randf_range(-1000,1000))
	angle = atan($FederationHead.global_position.direction_to(direction).y / $FederationHead.global_position.direction_to(direction).x)
	if Global.federationAngry == true:
		add_to_group("enemy")
func _process(delta):
	if is_in_group("One") && Global.federationOneHP <= 0 && $DespawnTime.time_left == 0:
		self_destruct()
	elif is_in_group("Two") && Global.federationTwoHP <= 0 && $DespawnTime.time_left == 0:
		self_destruct()
	elif is_in_group("Three") && Global.federationThreeHP <= 0 && $DespawnTime.time_left == 0:
		self_destruct()
		
	for x in $Tribute.get_overlapping_bodies():
		if x.is_in_group("PlayerVehicle") && Global.federationAngry == true:
			direction = x.global_position
	
	if $DespawnTime.time_left == 0:
		while segment > 0:
			match 15 - segment:
				1:
					if angle > 0:
						$FederationHead.rotate(speedRot / 2000) #gonna have to do a check somehow to make sure the "tail" won't flail to the other side
							
					elif angle < 0:
						$FederationHead.rotate(speedRot / -2000) #gonna have to do a check somehow to make sure the "tail" won't flail to the other side
					$FederationHead.move_local_x(speed)
					global_position = $FederationHead.global_position
					$FederationHead.move_local_x(-1 * (speed))
				2:
					$FederationBodyA.global_position = $FederationBodyA.global_position.lerp($FederationHead.global_position, speedPos)
					$FederationBodyA.global_rotation = lerp_angle($FederationBodyA.global_rotation, $FederationHead.global_rotation * rotateRate, speedRot)
					$FederationBodyA.move_local_x(dist)
				3:
					$FederationBodyB.global_position = $FederationBodyB.global_position.lerp($FederationBodyA.global_position, speedPos)
					$FederationBodyB.global_rotation = lerp_angle($FederationBodyB.global_rotation, $FederationBodyA.global_rotation * rotateRate, speedRot)
					$FederationBodyB.move_local_x(dist)
				4:
					$FederationBodyA2.global_position = $FederationBodyA2.global_position.lerp($FederationBodyB.global_position, speedPos)
					$FederationBodyA2.global_rotation = lerp_angle($FederationBodyA2.global_rotation, $FederationBodyB.global_rotation * rotateRate, speedRot)
					$FederationBodyA2.move_local_x(dist)
				5:
					$FederationBodyB2.global_position = $FederationBodyB2.global_position.lerp($FederationBodyA2.global_position, speedPos)
					$FederationBodyB2.global_rotation = lerp_angle($FederationBodyB2.global_rotation, $FederationBodyA2.global_rotation * rotateRate, speedRot)
					$FederationBodyB2.move_local_x(dist)
				6:
					$FederationBodyA3.global_position = $FederationBodyA3.global_position.lerp($FederationBodyB2.global_position, speedPos)
					$FederationBodyA3.global_rotation = lerp_angle($FederationBodyA3.global_rotation, $FederationBodyB2.global_rotation * rotateRate, speedRot)
					$FederationBodyA3.move_local_x(dist)
				7:
					$FederationBodyB3.global_position = $FederationBodyB3.global_position.lerp($FederationBodyA3.global_position, speedPos)
					$FederationBodyB3.global_rotation = lerp_angle($FederationBodyB3.global_rotation, $FederationBodyA3.global_rotation * rotateRate, speedRot)
					$FederationBodyB3.move_local_x(dist)
				8:
					$FederationBodyA4.global_position = $FederationBodyA4.global_position.lerp($FederationBodyB3.global_position, speedPos)
					$FederationBodyA4.global_rotation = lerp_angle($FederationBodyA4.global_rotation, $FederationBodyB3.global_rotation * rotateRate, speedRot)
					$FederationBodyA4.move_local_x(dist)
				9:
					$FederationBodyB4.global_position = $FederationBodyB4.global_position.lerp($FederationBodyA4.global_position, speedPos)
					$FederationBodyB4.global_rotation = lerp_angle($FederationBodyB4.global_rotation, $FederationBodyA4.global_rotation * rotateRate, speedRot)
					$FederationBodyB4.move_local_x(dist)
				10:
					$FederationBodyA5.global_position = $FederationBodyA5.global_position.lerp($FederationBodyB4.global_position, speedPos)
					$FederationBodyA5.global_rotation = lerp_angle($FederationBodyA5.global_rotation, $FederationBodyB4.global_rotation * rotateRate, speedRot)
					$FederationBodyA5.move_local_x(dist)
				11:
					$FederationBodyB5.global_position = $FederationBodyB5.global_position.lerp($FederationBodyA4.global_position, speedPos)
					$FederationBodyB5.global_rotation = lerp_angle($FederationBodyB5.global_rotation, $FederationBodyA4.global_rotation * rotateRate, speedRot)
					$FederationBodyB5.move_local_x(dist)
				12:
					$FederationBodyA6.global_position = $FederationBodyA6.global_position.lerp($FederationBodyB5.global_position, speedPos)
					$FederationBodyA6.global_rotation = lerp_angle($FederationBodyA6.global_rotation, $FederationBodyB5.global_rotation * rotateRate, speedRot)
					$FederationBodyA6.move_local_x(dist)
				13:
					$FederationBodyB6.global_position = $FederationBodyB6.global_position.lerp($FederationBodyA6.global_position, speedPos)
					$FederationBodyB6.global_rotation = lerp_angle($FederationBodyB6.global_rotation, $FederationBodyA6.global_rotation * rotateRate, speedRot)
					$FederationBodyB6.move_local_x(dist)
				14:
					$FederationTail.global_position = $FederationTail.global_position.lerp($FederationBodyB6.global_position, speedPos)
					$FederationTail.global_rotation = lerp_angle($FederationTail.global_rotation, $FederationBodyB6.global_rotation * rotateRate, speedRot)
					$FederationTail.move_local_x(dist)
			segment -= 1
		move_and_slide()
		segment = 14
	

func _on_direction_time_timeout():
	direction = global_position + Vector2(randf_range(-1000,1000),randf_range(-1000,1000))
	angle = atan($FederationHead.global_position.direction_to(direction).y / $FederationHead.global_position.direction_to(direction).x)
	angle /= 180 / PI


func _on_tribute_body_entered(body):
	if body.is_in_group("PlayerVehicle"):
		if Global.federationAngry == false && Global.crudSol >= 750:
			body.offer("federation")
			Global.enterPrompt = "federation"
		elif Global.federationAngry == false:
			body.offer("greeting")
		elif Global.federationAngry == true && Global.surrender != null:
			body.offer("surrender")
			Global.enterPrompt = "surrender"
		elif Global.federationAngry == true:
			body.offer("nosurrender")
		speed = 0.5
		


func _on_tribute_body_exited(body):
	Global.enterPrompt = "empty"
	speed = 1

func self_destruct():
	$FederationHead.die(0.7)
	$FederationBodyA.die(0.9)
	$FederationBodyB.die(1.1)
	$FederationBodyA2.die(1.3)
	$FederationBodyB2.die(1.5)
	$FederationBodyA3.die(1.7)
	$FederationBodyB3.die(1.9)
	$FederationBodyA4.die(2.1)
	$FederationBodyB4.die(2.3)
	$FederationBodyA5.die(2.5)
	$FederationBodyB5.die(2.7)
	$FederationBodyA6.die(2.9)
	$FederationBodyB6.die(3.1)
	$FederationTail.die(3.3)
	$DespawnTime.start()


func _on_despawn_time_timeout():
	queue_free()
