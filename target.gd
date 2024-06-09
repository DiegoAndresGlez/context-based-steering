extends CharacterBody2D

"""
Target can be Player, Enemy, or any other object that you want to follow.
"""

@export var max_speed = 250
@export var steer_force = 0.1
@export var look_ahead = 100

func get_player_input():
	var mouse_pos = get_global_mouse_position()
	var desired_velocity = (mouse_pos - global_position).normalized() * max_speed
	velocity = velocity.lerp(desired_velocity, steer_force)

func _physics_process(_delta):
	get_player_input()
	move_and_slide()