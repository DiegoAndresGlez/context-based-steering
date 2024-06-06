extends CharacterBody2D

@export var speed = 150

func _ready():
	global_position.x = get_viewport().size.x / 2
	global_position.y = get_viewport().size.y / 2

func _physics_process(delta):
	pass