extends Node2D

@export var actor : CharacterBody2D
@export var target : Node2D
@export var max_speed = 250
@export var steer_force = 0.1
@export var look_ahead = 100

@onready var raycasts = get_children() as Array[RayCast2D]
@export var num_rays = 8

var ray_directions = []
var interest = []
var danger = []

var chosen_dir := Vector2.ZERO
var target_dir := Vector2.ZERO
var velocity := Vector2.ZERO
var acceleration := Vector2.ZERO

func _ready():
	target = get_parent().owner.get_node("Target")
	print(target)
	interest.resize(num_rays)
	danger.resize(num_rays)
	ray_directions.resize(num_rays)
	for i in num_rays:
		var angle = i * 2 * PI / num_rays # radians
		ray_directions[i] = Vector2.DOWN.rotated(angle) # from bottom ray and clockwise 

func get_player_input():
	var mouse_pos = get_global_mouse_position()
	var desired_velocity = (mouse_pos - actor.global_position).normalized() * max_speed
	actor.velocity = actor.velocity.lerp(desired_velocity, steer_force)

func move_to_target():
	"""
	Simple move X object to Y target
	"""
	var desired_velocity = (target.global_position - actor.global_position).normalized() * max_speed
	actor.velocity = actor.velocity.lerp(desired_velocity, steer_force)

func _physics_process(delta):
	# get_player_input()
	# move_to_target()
	set_interest()
	set_danger()
	choose_direction()

	# TODO add pathfinding
	target_dir = (target.global_position - actor.global_position).normalized()
	var desired_velocity = chosen_dir.rotated(actor.rotation) * max_speed
	actor.velocity = actor.velocity.lerp(desired_velocity, steer_force)
	print(actor.velocity)
	actor.move_and_slide()

func set_interest():
	for i in num_rays:
		var d = ray_directions[i].dot(target_dir)
		interest[i] = max(0, d)

func set_danger():
	var i = 0
	for ray in raycasts:
		if ray.is_colliding():
			danger[i] = 1
		else:
			danger[i] = 0
		i += 1
	
func choose_direction():
	# Eliminate interest in index with danger
	for i in num_rays:
		if danger[i] > 0.0:
			interest[i] = 0.0
		
	# Choose direction based on remaining interest
	chosen_dir = Vector2.ZERO
	for i in num_rays:
		chosen_dir += ray_directions[i] * interest[i]
	print(interest)
	print(danger)
	chosen_dir = chosen_dir.normalized()
