extends CharacterBody2D

const MOVE_SPEED = 200

@onready var raycast = $RayCast2D

var player = null

func _ready():
	add_to_group("zombieRelic")

func set_player(p):
	player = p
