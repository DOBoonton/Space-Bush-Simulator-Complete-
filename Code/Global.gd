extends Node

var crudSol = 0
var maxCrudSol = 300
var maxSolar = 3000
var currentSolar = 3000
var vehicleX = 91458
var vehicleY = 60328
var tier = 1

var biome = "space"
var time = 0
var playMusic = true
var crisis = false
var mercy = false

var radarTarget

var harsh
var radar = 0

var day = "Mon"
var hour = 0
var minute = 0
var week = 1

var bits = 75
var sellState = 0
var quota = 5
var fired = false
var hasSold = false
var robot = false

var enterPrompt
var movement = true

var hq = Vector2(91608,60378)
var mars
var harshS
var goldalis
var rangerprime
var abandonedhqOne
var abandonedhqTwo
var harshL
var blackholeP
var banditOne
var banditTwo
var federationOne
var federationTwo
var federationThree
var pirateOne
var pirateTwo
var shop

var deaths = 0

var blackhole = false
var blackholeSize = 0
var blackholeRate = 1

var relic = 0
var relicLimit = 1

var shield = 2
var shieldLimit = 2
var shieldRecharge = 0.25
var damaged = false
var insured = 0

var banditsOne = 0
var banditsTwo = 0
var banditOneDefeat = false
var banditTwoDefeat = false

var boss = ""
var federationAngry = false
var federationOneHP = 200
var federationTwoHP = 200
var federationThreeHP = 200
var federationShips = 0

var underground = false
var undergroundProg = 0
var nebula = false
var farmer = false
var insurance = false
var astronomy = false
var beenJob = []

var relicOne = 1
var relicTwo = 2

var escape = ""
var surrender = false

var pause = false
var debug = false

func reset():
	crudSol = 0
	maxCrudSol = 300
	maxSolar = 3000
	currentSolar = 3000
	vehicleX = 91458
	vehicleY = 60328
	tier = 1

	biome = "space"
	time = 0
	playMusic = true
	crisis = false
	mercy = false

	radar = 0

	day = "Mon"
	hour = 0
	minute = 0
	week = 1

	bits = 75
	sellState = 0
	quota = 5
	fired = false
	hasSold = false
	robot = false
	
	movement = true
	
	blackhole = false
	blackholeSize = 0
	blackholeRate = 1
	
	relic = 0
	relicLimit = 1
	
	shield = 2
	shieldLimit = 2
	shieldRecharge = 0.25
	damaged = false
	insured = 0
	
	banditsOne = 0
	banditsTwo = 0
	banditOneDefeat = false
	banditTwoDefeat = false
	
	boss = ""
	federationAngry = false
	federationOneHP = 200
	federationTwoHP = 200
	federationThreeHP = 200
	federationShips = 0
	
	underground = false
	undergroundProg = 0
	nebula = false
	farmer = false
	insurance = false
	astronomy = false
	beenJob = []
	
	relicOne = 1
	relicTwo = 2
	
	escape = ""
	surrender = false
	
	pause = false
	
	hq = Vector2(91608,60378)
	
	if randi_range(0,1) == 0:
		harsh = "abyssari"
	else:
		harsh = "magmus"
	var i = 16
	while i > 0:
		var align = randi_range(0,3)
		match i:
			16:
				var angle = randf_range(0,360)
				shop = hq + Vector2(550 * cos(angle),550 * sin(angle))
			15:
				var min = 15000
				var max = 41320
				match align:
					0:
						pirateTwo = hq + Vector2(randi_range(min,max),randi_range(min,max))
					1:
						pirateTwo = hq + Vector2(-randi_range(min,max),randi_range(min,max))
					2:
						pirateTwo = hq + Vector2(randi_range(min,max),-randi_range(min,max))
					3:
						pirateTwo = hq + Vector2(-randi_range(min,max),-randi_range(min,max))
			14:
				var min = 15000
				var max = 41320
				match align:
					0:
						pirateOne = hq + Vector2(randi_range(min,max),randi_range(min,max))
					1:
						pirateOne = hq + Vector2(-randi_range(min,max),randi_range(min,max))
					2:
						pirateOne = hq + Vector2(randi_range(min,max),-randi_range(min,max))
					3:
						pirateOne = hq + Vector2(-randi_range(min,max),-randi_range(min,max))
			13:
				var min = 15000
				var max = 41320
				match align:
					0:
						federationThree = hq + Vector2(randi_range(min,max),randi_range(min,max))
					1:
						federationThree = hq + Vector2(-randi_range(min,max),randi_range(min,max))
					2:
						federationThree = hq + Vector2(randi_range(min,max),-randi_range(min,max))
					3:
						federationThree = hq + Vector2(-randi_range(min,max),-randi_range(min,max))
			12:
				var min = 15000
				var max = 41320
				match align:
					0:
						federationTwo = hq + Vector2(randi_range(min,max),randi_range(min,max))
					1:
						federationTwo = hq + Vector2(-randi_range(min,max),randi_range(min,max))
					2:
						federationTwo = hq + Vector2(randi_range(min,max),-randi_range(min,max))
					3:
						federationTwo = hq + Vector2(-randi_range(min,max),-randi_range(min,max))
			11:
				var min = 15000
				var max = 41320
				match align:
					0:
						federationOne = hq + Vector2(randi_range(min,max),randi_range(min,max))
					1:
						federationOne = hq + Vector2(-randi_range(min,max),randi_range(min,max))
					2:
						federationOne = hq + Vector2(randi_range(min,max),-randi_range(min,max))
					3:
						federationOne = hq + Vector2(-randi_range(min,max),-randi_range(min,max))
			10:
				var min = 15000
				var max = 41320
				match align:
					0:
						banditTwo = hq + Vector2(randi_range(min,max),randi_range(min,max))
					1:
						banditTwo = hq + Vector2(-randi_range(min,max),randi_range(min,max))
					2:
						banditTwo = hq + Vector2(randi_range(min,max),-randi_range(min,max))
					3:
						banditTwo = hq + Vector2(-randi_range(min,max),-randi_range(min,max))
			9:
				var min = 15000
				var max = 41320
				match align:
					0:
						banditOne = hq + Vector2(randi_range(min,max),randi_range(min,max))
					1:
						banditOne = hq + Vector2(-randi_range(min,max),randi_range(min,max))
					2:
						banditOne = hq + Vector2(randi_range(min,max),-randi_range(min,max))
					3:
						banditOne = hq + Vector2(-randi_range(min,max),-randi_range(min,max))
			8:
				var min = 2460
				var max = 2560
				match align:
					0:
						blackholeP = hq + Vector2(randi_range(min,max),randi_range(min,max))
					1:
						blackholeP = hq + Vector2(-randi_range(min,max),randi_range(min,max))
					2:
						blackholeP = hq + Vector2(randi_range(min,max),-randi_range(min,max))
					3:
						blackholeP = hq + Vector2(-randi_range(min,max),-randi_range(min,max))
			7:
				var min = 2560
				var max = 11520
				match align:
					0:
						mars = hq + Vector2(randi_range(min,max),randi_range(min,max))
					1:
						mars = hq + Vector2(-randi_range(min,max),randi_range(min,max))
					2:
						mars = hq + Vector2(randi_range(min,max),-randi_range(min,max))
					3:
						mars = hq + Vector2(-randi_range(min,max),-randi_range(min,max))
			6:
				var min = 7680
				var max = 15360
				match align:
					0:
						harshS = hq + Vector2(randi_range(min,max),randi_range(min,max))
					1:
						harshS = hq + Vector2(-randi_range(min,max),randi_range(min,max))
					2:
						harshS = hq + Vector2(randi_range(min,max),-randi_range(min,max))
					3:
						harshS = hq + Vector2(-randi_range(min,max),-randi_range(min,max))
			5:
				var min = 22320
				var max = 32280
				match align:
					0:
						goldalis = hq + Vector2(randi_range(min,max),randi_range(min,max))
					1:
						goldalis = hq + Vector2(-randi_range(min,max),randi_range(min,max))
					2:
						goldalis = hq + Vector2(randi_range(min,max),-randi_range(min,max))
					3:
						goldalis = hq + Vector2(-randi_range(min,max),-randi_range(min,max))
			4:
				var min = 27720
				var max = 42160
				match align:
					0:
						rangerprime = hq + Vector2(randi_range(min,max),randi_range(min,max))
					1:
						rangerprime = hq + Vector2(-randi_range(min,max),randi_range(min,max))
					2:
						rangerprime = hq + Vector2(randi_range(min,max),-randi_range(min,max))
					3:
						rangerprime = hq + Vector2(-randi_range(min,max),-randi_range(min,max))
			3:
				var min = 22880
				var max = 44800
				match align:
					0:
						abandonedhqOne = hq + Vector2(randi_range(min,max),randi_range(min,max))
					1:
						abandonedhqOne = hq + Vector2(-randi_range(min,max),randi_range(min,max))
					2:
						abandonedhqOne = hq + Vector2(randi_range(min,max),-randi_range(min,max))
					3:
						abandonedhqOne = hq + Vector2(-randi_range(min,max),-randi_range(min,max))
			2:
				var min = 37600
				var max = 45400
				match align:
					0:
						abandonedhqTwo = hq + Vector2(randi_range(min,max),randi_range(min,max))
					1:
						abandonedhqTwo = hq + Vector2(-randi_range(min,max),randi_range(min,max))
					2:
						abandonedhqTwo = hq + Vector2(randi_range(min,max),-randi_range(min,max))
					3:
						abandonedhqTwo = hq + Vector2(-randi_range(min,max),-randi_range(min,max))
			1:
				var min = 39500
				var max = 45400
				match align:
					0:
						harshL = hq + Vector2(randi_range(min,max),randi_range(min,max))
					1:
						harshL = hq + Vector2(-randi_range(min,max),randi_range(min,max))
					2:
						harshL = hq + Vector2(randi_range(min,max),-randi_range(min,max))
					3:
						harshL = hq + Vector2(-randi_range(min,max),-randi_range(min,max))
		i -= 1
	deaths += 1
	get_tree().change_scene_to_file("res://Scenes/Surfaces/hq.tscn")

func VectorToDistance(Vector):
	return sqrt((Vector.x * Vector.x)+(Vector.y * Vector.y))

func RoundSpec(number, place):
	var returnNum = ""
	place += 1
	var checkPlace = place
	
	number = str(number)
	var numberArray = []
	for x in number:
		numberArray.append(x)
		if x == ".":
			place += 1
		place -= 1
		
		if place == 0:
			var placement = 2
			if int(numberArray[len(numberArray) - 1]) >= 5:
				numberArray[len(numberArray) - 2] = str(int(numberArray[len(numberArray) - 2]) + 1)
				while int(numberArray[len(numberArray) - placement]) >= 10:
					numberArray[len(numberArray) - placement] = 0
					if numberArray[len(numberArray) - placement - 1] == ".":
						placement += 2
					else:
						placement += 1

			var numReplace = len(numberArray) - 2
			while numReplace >= 0:
				returnNum = str(numberArray[numReplace]) + returnNum
				numReplace -= 1
			
			var tenCheck = 0
			var tenChange = true
			for e in number:
				if checkPlace > 0:
					checkPlace -= 1
				elif tenChange == true:
					if e == ".":
						tenChange = false
					else:
						tenCheck += 1
					
			while tenCheck > 0:
				returnNum = int(returnNum) * (10 * tenCheck)
			
			return returnNum
	
	place -= 1
	if not "." in number:
		number = number + "."
	#var req = checkPlace - place
	while place > 0:
		number = str(number) + "0"
		place -= 1
	return float(number)

func _process(delta):
	if escape != "": #this is temporary until I add endings
		get_tree().change_scene_to_file("res://Scenes/Menus/ending1.tscn")
#	match escape:
#		"underground":
#
